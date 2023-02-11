Red []

do %quick-test.red
do %../document/document.red

~~~start-file~~~ "document"


makeDocumentWithFields: function[] [
    doc: make Document []
    
    doc/add Field-Prototype/with/store/index "keyword" "test1" 'YES 'UN_TOKENIZED
    doc/add Field-Prototype/with/store/index "keyword" "test2" 'YES 'UN_TOKENIZED
    doc/add Field-Prototype/with/store/index "text" "test1" 'YES 'TOKENIZED
    doc/add Field-Prototype/with/store/index "text" "test2" 'YES 'TOKENIZED
    doc/add Field-Prototype/with/store/index "unindexed" "test1" 'YES 'NO
    doc/add Field-Prototype/with/store/index "unindexed" "test2" 'YES 'NO
    doc/add Field-Prototype/with/store/index "unstored" "test1" 'NO 'TOKENIZED
    doc/add Field-Prototype/with/store/index "unstored" "test2" 'NO 'TOKENIZED

    doc

]

===start-group=== "field tests"

    str1:  "this text will be stored as a byte array in the index"
    str2: "this text will be also stored as a byte array in the index"
    doc: make Document []

    ; stringFld: Field/with/store/index "string" str1 'YES 'NO
    ; stringFld: copy Field
    stringFld: Field-Prototype/with/store/index "string" str1 'YES 'NO

    binaryFld: Field-Prototype/with/store "binary" to-binary str1 'YES

    binaryFld2: Field-Prototype/with/store "binary" to-binary str2 'YES

    doc/add stringFld
    doc/add binaryFld

    --test-- "field-test-1"	--assert (length? doc/fields) = 2
    --test-- "field-test-2"	--assert binaryFld/isBinary = true
    --test-- "field-test-3"	--assert binaryFld/isStored = true
    --test-- "field-test-4"	--assert binaryFld/isIndexed = false
    --test-- "field-test-5"	--assert binaryFld/isTokenized = false

    --test-- "field-test-6"	--assert (to-string (doc/getBinaryValue "binary")) = str1
    --test-- "field-test-7"	--assert (doc/get "string") = str1


    doc/add binaryFld2
    --test-- "field-test-8"	--assert (length? doc/fields) = 3

    binaryTests: doc/getBinaryValues "binary"
    --test-- "field-test-9"	--assert (length? binaryTests) = 2

    binary-val-1: to-string first binaryTests
    binary-val-2: to-string second binaryTests
    --test-- "field-test-10"	--assert ( binary-val-1 <>  binary-val-2)
    --test-- "field-test-11"	--assert binary-val-1 = str1
    --test-- "field-test-12"	--assert binary-val-2 = str2

    doc/remove-field "string"
    --test-- "field-test-13"	--assert (length? doc/fields) = 2

    doc/remove-fields "binary"
    --test-- "field-test-14"	--assert (length? doc/fields) = 0

===start-group=== "remove field tests"
    doc: makeDocumentWithFields

    --test-- "remove-field-test-1"	--assert (length? doc/fields) = 8

    doc/remove-fields "keyword"
    --test-- "remove-field-test-2"	--assert (length? doc/fields) = 6


    doc/remove-fields "doesnotexists"
    doc/remove-fields "keyword"
    --test-- "remove-field-test-3"	--assert (length? doc/fields) = 6

    doc/remove-field "text"
    --test-- "remove-field-test-4"	--assert (length? doc/fields) = 5
    doc/remove-field "text"
    --test-- "remove-field-test-5"	--assert (length? doc/fields) = 4
    doc/remove-field "doesnotexists"
    --test-- "remove-field-test-6"	--assert (length? doc/fields) = 4

    doc/remove-fields "unindexed"
    --test-- "remove-field-test-7"	--assert (length? doc/fields) = 2

    doc/remove-fields "unstored"
    --test-- "remove-field-test-8"	--assert (length? doc/fields) = 0

    doc/remove-fields "doesnotexists"
    --test-- "remove-field-test-9"	--assert (length? doc/fields) = 0

===start-group=== "get values for new doc tests"
    doc: makeDocumentWithFields
    keywordFieldValues: doc/getValues "keyword"
    textFieldValues: doc/getValues "text"
    unindexedFieldValues: doc/getValues "unindexed"
    unstoredFieldValues: doc/getValues "unstored"

    --test-- "get-values-test-1"	--assert (length? keywordFieldValues) = 2
    --test-- "get-values-test-2"	--assert (length? textFieldValues) = 2
    --test-- "get-values-test-3"	--assert (length? unindexedFieldValues) = 2
    --test-- "get-values-test-4"	--assert (length? unstoredFieldValues) = 2

    --test-- "get-values-test-5"	--assert keywordFieldValues/1 = "test1"
    --test-- "get-values-test-5"	--assert keywordFieldValues/2 = "test2"
    --test-- "get-values-test-5"	--assert textFieldValues/1 = "test1"
    --test-- "get-values-test-5"	--assert textFieldValues/2 = "test2"
    --test-- "get-values-test-5"	--assert unindexedFieldValues/1 = "test1"
    --test-- "get-values-test-5"	--assert unindexedFieldValues/2 = "test2"
    --test-- "get-values-test-5"	--assert unstoredFieldValues/1 = "test1"
    --test-- "get-values-test-5"	--assert unstoredFieldValues/2 = "test2"

===end-group===
~~~end-file~~~