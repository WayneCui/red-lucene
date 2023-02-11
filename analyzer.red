Red []

Token-Obj: make object! [
    termText: none
    startOffset: 0
    endOffset: 0
    type: 'word

    positionIncrement: 1
]

Analyzer: object [
    token-stream: function [ input-data ][

    ]

    getPositionIncrementGap: function [ field-name ] [
        0
    ]
]

SimpleAnalyzer: make Analyzer [
    token-stream: func[ input-data ][
        tokenizer: copy lowercase-tokenizer
        tokenizer/input-data: copy input-data

        tokenizer
    ]
]

WhitespaceAnalyzer: make Analyzer [
    token-stream: func[ input-data ][
        tokenizer: copy whitespace-tokenizer
        tokenizer/input-data: copy input-data

        tokenizer
    ]
]

; StopAnalyzer: make object! [
;     ENGLISH_STOP_WORDS: [
;         "a"  "an"  "and"  "are"  "as"  "at"  "be"  "but"  "by" 
;         "for"  "if"  "in"  "into"  "is"  "it" 
;         "no"  "not"  "of"  "on"  "or"  "s"  "such" 
;         "t"  "that"  "the"  "their"  "then"  "there"  "these" 
;         "they"  "this"  "to"  "was"  "will"  "with"
;     ]
;     stopWords: copy []
; ]

; tokenizer
char-tokenizer: make object! [
    input-data: none
    offset: 1
    token-rule: charset [#"a" - #"z" #"A" - #"Z"]

    has-next: func[][
        ; probe length? input-data
        ; probe offset
        return offset <= length? input-data
    ]

    next: func [ /local length start ][
        length: 0
        start: offset
        token: none
        ; probe offset

        if not empty? at input-data offset [
            parse at input-data offset [
                [to token-rule mark: (start: index? mark) copy token some token-rule
                (
                    length: length? token 
                    offset: start + length
                ) |
                to end (offset: (length? input-data) + 1)
                ]
            ] 

            either none? token  [
                return none
            ][
                return make Token-Obj [termText: (normalize token) startOffset: start endOffset: (start + length)]
            ]
        ]

        return none
    ]

    normalize: func [str [any-string! char!]][ str ]
]

lowercase-tokenizer: make char-tokenizer [
    normalize: func [str [any-string! char!]][ lowercase str ]
]

whitespace-tokenizer: make char-tokenizer [
    token-rule: charset reduce [ 'not space ]
]