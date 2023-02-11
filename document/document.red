Red [

]

Document: make object! [
    fields: copy []
    boost: 1.0

    getBinaryValue: function [ name [string!]][
        foreach field fields [
            if field/name = name and field/isBinary [
                return field/binaryValue
            ]
        ]
    ]

    getBinaryValues: function [ name [string!] /local blk ][
        blk: copy []
        foreach field fields [
            if (field/name = name) and (field/isBinary) [
                append blk field/binaryValue
            ]
        ]

        either empty? blk [ return none ] [ blk ]
    ]

    get: function [ name [string!]][
        foreach field fields [
            if field/name = name and not field/isBinary [
                return field/stringValue
            ]
        ]
    ]

    getValues: function [ name [string!] /local blk] [
        blk: copy []
        foreach field fields [
            ; probe field/name
            ; probe field/isBinary
            if field/name = name and not (field/isBinary) [
                append blk field/stringValue
            ]
        ]

        either empty? blk [ return none ] [ blk ]
    ]

    add: function [ field ][
        append fields field
    ]

    remove-field: function [ name [string!]][
        idx: 1
        foreach field fields [
            if field/name = name [
                remove at fields idx
                break
            ]
            idx: idx + 1
        ]
    ]

    remove-fields: function [ name [string!]][
        self/fields: collect [
            foreach field self/fields [
                if field/name <> name [
                    keep field
                ]
            ]
        ]
    ]
]


Field-Prototype: make object! [
    name: "body"
  
    ;the one and only data object for all different kind of field values
    fieldsData: none
    
    storeTermVector: false
    storeOffsetWithTermVector: false 
    storePositionWithTermVector: false

    isStored: false
    isCompressed: false

    isIndexed: true
    isTokenized: true
    omitNorms: false

    isBinary: false
    
    boost: 1.0

    binaryValue: does [
        either binary? fieldsData [ fieldsData ][ none ]
    ]

    stringValue: does [
        either string? fieldsData [ fieldsData ][ none ]
    ]

    with: function [ name [string!] value  /store store-enum [word!] /index index-enum [word!] /term-vector term-vector-enum [word!]][
        field-obj: make Field-Prototype []
        if empty? name  [ throw "name cannot be null"] 
        if empty? value [ throw "value cannot be null"] 
        ; if index: 'NO and store: 'NO [ throw "it doesn't make sense to have a field that is neither indexed nor stored"]
        ; if index: 'NO and termVector != 'NO [throw "cannot store term vector information for a field that is not indexed"]
        field-obj/name: name
        field-obj/fieldsData: value
        
        if binary? field-obj/fieldsData [
            field-obj/isIndexed:     false
            field-obj/isTokenized:  false
            field-obj/isBinary:     true

            setStoreTermVector 'NO
        ]

        if store [
            switch store-enum [
                YES [
                    field-obj/isStored: true
                    field-obj/isCompressed: false
                ]
                COMPRESS [
                    field-obj/isStored: true
                    field-obj/isCompressed: true
                ]
                NO [
                    field-obj/isStored: false
                    field-obj/isCompressed: false
                ]
                default [ throw reduct ["unknown store parameter " store]]
            ]
        ]

        if index [
            switch index [
                NO [
                    field-obj/isIndexed: false
                    field-obj/isTokenized: false
                ]
                TOKENIZED [
                    field-obj/isIndexed: true
                    field-obj/isTokenized: true
                ]

                UN_TOKENIZED [
                    field-obj/isIndexed: true
                    field-obj/isTokenized: false
                ]

                NO_NORMS [
                    field-obj/isIndexed: true
                    field-obj/isTokenized: false
                    field-obj/omitNorms: true
                ]

                default [ throw reduct ["unknown index parameter " store]]
            ]
        ]
        
        if term-vector [
            setStoreTermVector term-vector
        ]

        field-obj
    ]

    setStoreTermVector: function [ term-vector [word!]][
        switch term-vector [
            NO [
                storeTermVector: false
                storePositionWithTermVector: false
                storeOffsetWithTermVector: false
            ]

            YES [
                storeTermVector: true
                storePositionWithTermVector: false
                storeOffsetWithTermVector: false
            ]

            WITH_POSITIONS [
                storeTermVector: true
                storePositionWithTermVector: true
                storeOffsetWithTermVector: false
            ]

            WITH_OFFSETS [
                storeTermVector: true
                storePositionWithTermVector: false
                storeOffsetWithTermVector: true
            ]

            WITH_POSITIONS_OFFSETS [
                storeTermVector: true
                storePositionWithTermVector: true
                storeOffsetWithTermVector: true
            ]

            default [ throw reduct ["unknown termVector parameter " term-vector]]
        ]
    ]
]