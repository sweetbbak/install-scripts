#!/bin/env python3
import os


def filter(opts: list):
    oxot = []
    for options in opts:
        oxot.append(f'"{options}"')
    options = " ".join(oxot)
    result = os.popen(f"./gum choose {options}")
    return result.read().replace(r"\n", "\n").strip().split("\n")


movies = [
    "https://37.187.117.176:38946/ghost_in_the_shell%5B1856x1008.h264.flac.ac3%5D%5Bniizk%5D.mkv",
    "https://37.187.117.176:38946/%5BCoalgirls%5D_Yahari_Ore_no_Seishun_Love_Comedy_wa_Machigatteiru_OVA_%281920x1080_Blu-Ray_FLAC%29_%5B7C46CB48%5D.mkv",
    # "",
]
