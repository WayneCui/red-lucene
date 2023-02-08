Red []

do %quick-test.red
do %../analyzer.red
~~~start-file~~~ "encode"

collect-term-text: func[ tokenizer ][
    collect [
        while [tokenizer/has-next][
            token: tokenizer/next
            if not none? token [keep token/termText]
        ]
    ]
]

===start-group=== "simple analyzer tests"
    analyzer: SimpleAnalyzer
    --test-- "simple analyzer-1"	--assert strict-equal? (collect-term-text (analyzer/token-stream "foo bar FOO BAR")) ["foo" "bar" "foo" "bar"]
    --test-- "simple analyzer-2"	--assert strict-equal? (collect-term-text (analyzer/token-stream "foo      bar .  FOO <> BAR")) ["foo" "bar" "foo" "bar"]
    --test-- "simple analyzer-3"	--assert strict-equal? (collect-term-text (analyzer/token-stream "foo.bar.FOO.BAR"))            ["foo" "bar" "foo" "bar"]
    --test-- "simple analyzer-4"	--assert strict-equal? (collect-term-text (analyzer/token-stream "U.S.A."))                     ["u" "s" "a"]
    --test-- "simple analyzer-1"	--assert strict-equal? (collect-term-text (analyzer/token-stream "C++"))                        ["c"]
    --test-- "simple analyzer-1"	--assert strict-equal? (collect-term-text (analyzer/token-stream "B2B"))                        ["b" "b"]
    --test-- "simple analyzer-1"	--assert strict-equal? (collect-term-text (analyzer/token-stream "2B"))                         ["b"]
    --test-- "simple analyzer-1"	--assert strict-equal? (collect-term-text (analyzer/token-stream {"QUOTED" word}))              ["quoted" "word"]

===start-group=== "whitespace analyzer tests"
    analyzer: WhitespaceAnalyzer
    --test-- "whitespace analyzer-1"	--assert strict-equal? (collect-term-text (analyzer/token-stream "foo bar FOO BAR"))            ["foo" "bar" "FOO" "BAR" ]
    --test-- "whitespace analyzer-2"	--assert strict-equal? (collect-term-text (analyzer/token-stream "foo      bar .  FOO <> BAR")) ["foo" "bar" "." "FOO" "<>" "BAR" ]
    --test-- "whitespace analyzer-3"	--assert strict-equal? (collect-term-text (analyzer/token-stream "foo.bar.FOO.BAR"))            ["foo.bar.FOO.BAR"]
    --test-- "whitespace analyzer-4"	--assert strict-equal? (collect-term-text (analyzer/token-stream "U.S.A."))                     ["U.S.A." ]
    --test-- "whitespace analyzer-5"	--assert strict-equal? (collect-term-text (analyzer/token-stream "C++"))                        ["C++" ]
    --test-- "whitespace analyzer-6"	--assert strict-equal? (collect-term-text (analyzer/token-stream "B2B"))                        ["B2B"]
    --test-- "whitespace analyzer-7"	--assert strict-equal? (collect-term-text (analyzer/token-stream "2B"))                         ["2B"]
    --test-- "whitespace analyzer-8"	--assert strict-equal? (collect-term-text (analyzer/token-stream {"QUOTED" word}))              [{"QUOTED"} "word"]

; ===start-group=== "stop analyzer tests"
;     analyzer: StopAnalyzer
;     --test-- "stop analyzer-1"	--assert strict-equal? (collect-term-text (analyzer/token-stream "foo bar FOO BAR"))                 ["foo" "bar" "foo" "bar"]
;     --test-- "stop analyzer-2"	--assert strict-equal? (collect-term-text (analyzer/token-stream "foo a bar such FOO THESE BAR"))    [ "foo" "bar" "foo" "bar"]


===end-group===
~~~end-file~~~