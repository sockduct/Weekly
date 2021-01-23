#! /usr/bin/env python3

'''Letters to words challenge assistant.
   This program takes a collection of letters entered as a string and returns
   all possible valid English words.
'''

# Standard libraries:
from collections import defaultdict
from itertools import permutations
from pathlib import Path
import sys

# Third part libraries:
from english_words import english_words_lower_alpha_set as english_dict

# Global Constants:
# Available from https://github.com/dwyl/english-words.git
WORD_FILE = 'C:\working\github\english-words\words_alpha.txt'
# Minimum word length:
WORD_MIN = 2


def create_permutations(letters):
    letter_permutations = set()

    for i in range(WORD_MIN, len(letters) + 1):
        letter_permutations.update(
            {''.join(letter_set) for letter_set in permutations(letters, i)})

    return letter_permutations


def find_words(word_list, word_set):
    return {word for word in word_list if word in word_set}


def initialize(word_file=WORD_FILE):
    word_set = set()

    with open(word_file) as word_file_handle:
        for word in word_file_handle:
            word_set.add(word.strip())

    return word_set


def usage(invocation):
    basename = Path(invocation).name
    print(f'{basename} <letters>\n\tWhere letters is a string of letters you'
          f' want to build words from.\n\te.g., {basename} "oxefaqz"\n'
          f'\n\tNote:  Only American letters (a-z) are allowed.\n')

    sys.exit(1)


def main(argv):
    letters = str()

    if len(argv) != 2 or argv[1].lower() in ('-h', '--help'):
        usage(argv[0])
    else:
        letters = argv[1].lower()

        if not letters.isalpha():
            usage(argv[0])

    # word_set = initialize()
    # Alternate:
    word_set = english_dict
    letter_permutations = create_permutations(letters)
    results = find_words(letter_permutations, word_set)

    print(f'Found {len(results)} words:')

    # Note:  Depending on dict being ordered (Python v3.6+)
    ordered_results = defaultdict(list)
    for word in sorted(results):
        word_len = len(word)
        ordered_results[word_len].append(word)

    for i in range(WORD_MIN, len(letters) + 1):
        for word in ordered_results[i]:
            print(word)


if __name__ == '__main__':
    main(sys.argv)
