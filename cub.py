#!/usr/bin/env python

'''
Quick and dirty C undefined behaviour finder.

This script does some extremely unrigorous analysis of C files by regexing
lines for common mistaken idioms that invoke undefined behaviour. It generates
many, many false positives, so the idea is to use it on a small code base or
apply it to a large code base as `cub.py myproject/ | wc -l` to get a coarse
grained WTF measure.
'''

import argparse, os, re, sys

UNDEF_SHIFT = re.compile(r'[^\d]1\s*<<\s*(\d+)')
NEGATE_SELF = re.compile(r'([a-zA-Z_]\w*)\s*=\s*-\s*([a-zA-Z_]\w*)')
MODIFY_TWICE = re.compile(r'\[\s*(?P<pre1>(?:\+\+)|(?:--))?\s*(?P<id1>[a-zA-Z_]\w*)\s*(?P<post1>(?:\+\+)|(?:--))?\s*\]\s*=\s*(?P<pre2>(?:\+\+)|(?:--))?\s*(?P<id2>[a-zA-Z_]\w*)\s*(?P<post2>(?:\+\+)|(?:--))?')
GUARD_IFNDEF = re.compile(r'\s*#\s*ifndef\s+(?P<guard>\w+)\s*$')
GUARD_DEF = re.compile(r'\s*#\s*define\s+(?P<guard>\w+)\s*$')

def scan_file(filepath):

    def write_line(lineno, line):
        sys.stderr.write('%s:%d: %s' % (filepath, lineno, line))

    with open(filepath) as f:
        ifndef_guard = None
        mmap_var = None

        for lineno, line in enumerate(f, 1):

            # Undefined left shifts into the sign bit.
            m = UNDEF_SHIFT.search(line)
            if m is not None:
                operand = int(m.group(1))
                if operand >= 31:
                    write_line(lineno, line)
                    sys.stderr.write(' potential undefined left shift\n')

            # A common mistake that leads to negating INT_MIN and cousins.
            m = NEGATE_SELF.search(line)
            if m is not None:
                id1 = m.group(1)
                id2 = m.group(2)
                if id1 == id2:
                    write_line(lineno, line)
                    sys.stderr.write(' potential negation of INT_MIN\n')

            # Modification of a variable twice without an intervening sequence point.
            m = MODIFY_TWICE.search(line)
            if m is not None and m.group('id1') == m.group('id2') and (m.group('pre1') is not None or m.group('pre2') is not None or m.group('post1') is not None or m.group('post2') is not None):
                write_line(lineno, line)
                sys.stderr.write(' potential duplicate modification of %s within a sequence point\n' % m.group('id1'))

            # Find mismatched header guards.
            if ifndef_guard is not None:
                m = GUARD_DEF.match(line)
                if m is not None:
                    if ifndef_guard != m.group('guard'):
                        write_line(lineno, line)
                        sys.stderr.write(' guard define does not match preceding #ifndef\n')
                ifndef_guard = None
            m = GUARD_IFNDEF.match(line)
            if m is not None:
                ifndef_guard = m.group('guard')

            # Find bad memset calls
            m = re.search(r'memset\s*\(.*,\s*0\s*\)', line);
            if m is not None:
                write_line(lineno, line)
                sys.stderr.write(' incorrect argument order to memset?\n')

            # Catch mmaps that don't compare to MAP_FAILED
            if mmap_var is None:
                m = re.search(r'([a-zA-Z_]\w*)\s*=\s*mmap\s*\(', line)
                if m is not None:
                    mmap_var = m.group(1)
            else:
                m = re.search(r'([a-zA-Z_]\w*)\s*==\s*(NULL|0)', line)
                if m is not None and m.group(1) == mmap_var:
                    write_line(lineno, line)
                    sys.stderr.write(' result of mmap incorrectly compared to NULL\n')
                mmap_var = None

def main(argv):
    parser = argparse.ArgumentParser(
        description='C undefined behaviour linter')
    parser.add_argument('path', help='file or directory to scan')
    opts = parser.parse_args(argv[1:])

    if os.path.isdir(opts.path):
        for root, _, files in os.walk(opts.path):
            for f in (x for x in files if os.path.splitext(x)[-1] in
                    ('.c', '.cpp', '.h', '.hpp')):
                scan_file(os.path.join(root, f))
    elif os.path.isfile(opts.path):
        scan_file(opts.path)
    else:
        sys.stderr.write('%s does not exist\n' % opts.path)
        return -1

    return 0

if __name__ == '__main__':
    sys.exit(main(sys.argv))
