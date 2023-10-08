#!/bin/env python3
# convert numbers into different number systems
# iterative version
import sys


def user_input():
    number = int(input("decimal number to convert: "))
    return number


def decimal_to_binary(number):
    # decimal to binary
    decimal_number = ""
    # set div to a number to make the while loop work
    div = 1
    while div != 0:
        div = number // 2
        reminder = number % 2
        number = div
        # print(reminder)
        decimal_number += str(reminder)
    return print("binary: ", decimal_number[::-1])


def decimal_to_octal(number):
    octal_number = ""
    div = 1
    while div != 0:
        div = number // 8
        reminder = number % 8
        number = div
        octal_number += str(reminder)
    return print("octal: ", octal_number[::-1])


def decimal_to_duodecimal(number):
    duodecimal_number = ""
    div = 1
    while div != 0:
        div = number // 12
        reminder = number % 12
        if reminder > 9:
            reminder = switcher(reminder)
        number = div
        duodecimal_number += str(reminder)
    return print("duodecimal: ", duodecimal_number[::-1])


def decimal_to_hex(number):
    hex_number = ""
    div = 1
    while div != 0:
        div = number // 16
        reminder = number % 16
        if reminder > 9:
            reminder = switcher(reminder)
        number = div
        hex_number += str(reminder)
    return print("hexadezimal: ", hex_number[::-1])


# switcher to select the correct char for hex number lager then 9
def switcher(n):
    switcher = {10: "A", 11: "B", 12: "C", 13: "D", 14: "E", 15: "F"}
    return switcher.get(n)


def main():
    # number = user_input()
    try:
        number = int(sys.argv[1])
    except IndexError:
        number = user_input()
    decimal_to_binary(number)
    decimal_to_octal(number)
    decimal_to_duodecimal(number)
    decimal_to_hex(number)


if __name__ == "__main__":
    main()
