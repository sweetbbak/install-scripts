#!/bin/bash

YAML=$(cat <<EOF
%YAML 1.2
---
# http://www.sublimetext.com/docs/3/syntax.html
name: Man
file_extensions:
  - man
scope: source.man

variables:
  section_heading: '^\S.*$'

contexts:
  main:
    - match: ^
      push: first_line

  first_line:
    - match: '([A-Z0-9]+)(\()([^)]+)(\))'
      captures:
        1: meta.preprocessor
        2: keyword.operator
        3: string.quoted.other
        4: keyword.operator

    - match: '$'
      push: body

  body:
    - match: '^(SYNOPSIS|SYNTAX|SINTASSI|SKŁADNIA|СИНТАКСИС|書式)'
      push: Packages/C/C.sublime-syntax
      scope: markup.heading
      with_prototype:
        - match: '(?={{section_heading}})'
          pop: true

    - match: '^\S.*$'
      scope: markup.heading

    - match: '\b([a-z0-9_]+)(\()([^)]*)(\))'
      captures:
        1: entity.name.function
        2: keyword.operator
        3: constant.numeric
        4: keyword.operator
EOF
)

# add Yaml file for syntax
[ ! -f "$HOME/.config/bat/syntaxes/Man.sublime-syntax" ] && {
    mkdir -p "$HOME/.config/bat/syntaxes/"
    printf "%s\n" "$YAML" > "$HOME/.config/bat/syntaxes/Man.sublime-syntax"
}
# echo 'export MANPAGER="sh -c 'sed -e s/.\\\\x08//g | bat -p -l man'"' >> ~/.zshrc
# bat cache --build

 
