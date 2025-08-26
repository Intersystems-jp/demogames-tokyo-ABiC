# システムプロンプト
system_prompt = '''
    あなたはIRISの組み込みBIの定義を理解できます。
    IRISに定義されているキューブ情報を「定義されたキューブ情報です。」以降にJSONで渡しています。
    ユーザが依頼する内容に対して、適切なキューブ、メジャー、ディメンジョン、フィルターを回答してください。
    回答に含めてほしい情報として、ディメンジョン名、ディメンジョンのMDX式
    メジャー名、メジャーのMDX式、フィルター対象があればフィルタ名とフィルターのMDX式を含めてください。
    回答は正しいJSONで回答例「表記例のJSONです。」以降のJSONを参考にしてください。
    フィルターが1つの場合であっても、mdx_whereはJSON配列で返してください。
    連続勤務日数が指定されたときは、ABiCAttendanceCubeキューブではなく、ABiCConsecutiveDayCubeキューブを使用してください。
    日付に関するディメンジョンは年と月の正しいMDX表現で別のディメンジョンとして返してください。
    応答はJSONだけを返してください。前後に```jsonや```のような不要な文字列は含まないでください。
'''
# APIkey
key=""

# System-prompt-forSummary
forSummary= '''
    前回渡したIRIS BIのキューブやディメンジョンなどの情報を元に実行したMDXの結果をJSONで送ります。
    Info.MDXTextのMDX式、Resultは分析結果です。分析結果から特徴や傾向を英語、日本語それぞれ200文字程度のサマリを作ってください。
    また、前回渡したIRIS BIのキューブ、ディメンジョン、メジャーの定義情報を元に、新しい分析を3パタン英語と日本語で作り返送してください。分析できない内容は返さないでください。MDX式は不要です。
    回答が英語版か日本語版かわかりやすい見出しを付けてください。見出しも英語版には英語、日本語版には日本語で記載してください。
    '''

# MDX情報
mdxinfo=[
    {
        "Cube": "ABiCAttendanceCube",
        "Dimensions": [
            [
                {
                    "List": [
                        "NightShiftFlag"
                    ],
                    "Name": "NightShiftFlag",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "OvertimeHour"
                    ],
                    "Name": "OvertimeHour",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "ShiftName"
                    ],
                    "Name": "ShiftName",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "Department"
                    ],
                    "Name": "Department",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "Year"
                    ],
                    "Name": "DateOfEx",
                    "Hierarchy": "H1"
                },
                {
                    "List": [
                        "Month"
                    ],
                    "Name": "DateOfEx",
                    "Hierarchy": "H1"
                },
                {
                    "List": [
                        "Day"
                    ],
                    "Name": "DateOfEx",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "EmpRole"
                    ],
                    "Name": "EmpRole",
                    "Hierarchy": "H1"
                }
            ]
        ],
        "Measures": [
            [
                {
                    "name": "%COUNT",
                    "caption": "カウント",
                    "type": "integer",
                    "hidden": 0,
                    "factName": ""
                },
                {
                    "name": "DayShift",
                    "caption": "DayShift",
                    "type": "boolean",
                    "hidden": 0,
                    "factName": "Mx250278431B"
                },
                {
                    "name": "NightShiftFlag",
                    "caption": "NightShiftFlag",
                    "type": "integer",
                    "hidden": 0,
                    "factName": "Mx104473082I"
                },
                {
                    "name": "OvertimeHourMax",
                    "caption": "OvertimeHourMax",
                    "type": "number",
                    "hidden": 0,
                    "factName": "MxOvertimeHourN"
                },
                {
                    "name": "WorkHourAVG",
                    "caption": "WorkHourAVG",
                    "type": "number",
                    "hidden": 0,
                    "factName": "MxWorkHourN"
                }
            ]
        ]
    },
    {
        "Cube": "ABiCClinicDataCube",
        "Dimensions": [
            [
                {
                    "List": [
                        "Department"
                    ],
                    "Name": "Department",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "TestName"
                    ],
                    "Name": "TestName",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "Year"
                    ],
                    "Name": "AdmissionDate",
                    "Hierarchy": "H1"
                },
                {
                    "List": [
                        "Month"
                    ],
                    "Name": "AdmissionDate",
                    "Hierarchy": "H1"
                },
                {
                    "List": [
                        "Day"
                    ],
                    "Name": "AdmissionDate",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "Year"
                    ],
                    "Name": "DischargeDate",
                    "Hierarchy": "H1"
                },
                {
                    "List": [
                        "Month"
                    ],
                    "Name": "DischargeDate",
                    "Hierarchy": "H1"
                },
                {
                    "List": [
                        "Day"
                    ],
                    "Name": "DischargeDate",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "Gender"
                    ],
                    "Name": "Gender",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "AdmissionFlg"
                    ],
                    "Name": "AdmissionFlg",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "Diagnosis"
                    ],
                    "Name": "Diagnosis",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "LengthOfStay"
                    ],
                    "Name": "LengthOfStay",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "Year"
                    ],
                    "Name": "DateOfEx",
                    "Hierarchy": "H1"
                },
                {
                    "List": [
                        "Month"
                    ],
                    "Name": "DateOfEx",
                    "Hierarchy": "H1"
                },
                {
                    "List": [
                        "Day"
                    ],
                    "Name": "DateOfEx",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "HospitalStay"
                    ],
                    "Name": "HospitalStay",
                    "Hierarchy": "H1"
                }
            ]
        ],
        "Measures": [
            [
                {
                    "name": "%COUNT",
                    "caption": "カウント",
                    "type": "integer",
                    "hidden": 0,
                    "factName": ""
                },
                {
                    "name": "AgeAVG",
                    "caption": "AgeAVG",
                    "type": "number",
                    "hidden": 0,
                    "factName": "MxAgeViaPIDN"
                },
                {
                    "name": "LenghtOfStayAVG",
                    "caption": "LenghtOfStayAVG",
                    "type": "number",
                    "hidden": 0,
                    "factName": "Mx3833179542"
                }
            ]
        ]
    },
    {
        "Cube": "ABiCConsecutiveDayCube",
        "Dimensions": [
            [
                {
                    "List": [
                        "NightShiftFlag"
                    ],
                    "Name": "NightShiftFlag",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "ShiftName"
                    ],
                    "Name": "ShiftName",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "Status"
                    ],
                    "Name": "Status",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "EmpType"
                    ],
                    "Name": "EmpType",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "EmpRole"
                    ],
                    "Name": "EmpRole",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "EndDateYear"
                    ],
                    "Name": "EndDate",
                    "Hierarchy": "H1"
                },
                {
                    "List": [
                        "EndDateMonth"
                    ],
                    "Name": "EndDate",
                    "Hierarchy": "H1"
                },
                {
                    "List": [
                        "EndDateDay"
                    ],
                    "Name": "EndDate",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "Year"
                    ],
                    "Name": "DateOfEx",
                    "Hierarchy": "H1"
                },
                {
                    "List": [
                        "Month"
                    ],
                    "Name": "DateOfEx",
                    "Hierarchy": "H1"
                },
                {
                    "List": [
                        "Day"
                    ],
                    "Name": "DateOfEx",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "Department"
                    ],
                    "Name": "Department",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "ConsecutiveDay"
                    ],
                    "Name": "ConsecutiveDay",
                    "Hierarchy": "H1"
                }
            ]
        ],
        "Measures": [
            [
                {
                    "name": "%COUNT",
                    "caption": "カウント",
                    "type": "integer",
                    "hidden": 0,
                    "factName": ""
                },
                {
                    "name": "ConsecutiveDayAVG",
                    "caption": "ConsecutiveDayAVG",
                    "type": "integer",
                    "hidden": 0,
                    "factName": "MxConsecutiveDay"
                },
                {
                    "name": "ConsecutiveDaysMax",
                    "caption": "ConsecutiveDaysMax",
                    "type": "integer",
                    "hidden": 0,
                    "factName": "MxConsecutiveDay"
                },
                {
                    "name": "DayShift",
                    "caption": "DayShift",
                    "type": "boolean",
                    "hidden": 0,
                    "factName": "Mx407274181B"
                },
                {
                    "name": "NightShiftFlag",
                    "caption": "NightShiftFlag",
                    "type": "boolean",
                    "hidden": 0,
                    "factName": "Mx861978979"
                },
                {
                    "name": "OvertimeHour",
                    "caption": "OvertimeHour",
                    "type": "number",
                    "hidden": 0,
                    "factName": "MxOvertimeHourN"
                },
                {
                    "name": "WorkHour",
                    "caption": "WorkHour",
                    "type": "number",
                    "hidden": 0,
                    "factName": "MxWorkHourN"
                }
            ]
        ]
    },
    {
        "Cube": "ABiCIncidentReportCube",
        "Dimensions": [
            [
                {
                    "List": [
                        "HarmScore"
                    ],
                    "Name": "HarmScore",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "DurationOfHarm"
                    ],
                    "Name": "DurationOfHarm",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "ReportLevel"
                    ],
                    "Name": "ReportLevel",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "Year"
                    ],
                    "Name": "DateOfEx",
                    "Hierarchy": "H1"
                },
                {
                    "List": [
                        "Month"
                    ],
                    "Name": "DateOfEx",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "Department"
                    ],
                    "Name": "Department",
                    "Hierarchy": "H1"
                }
            ]
        ],
        "Measures": [
            [
                {
                    "name": "%COUNT",
                    "caption": "カウント",
                    "type": "integer",
                    "hidden": 0,
                    "factName": ""
                }
            ]
        ]
    },
    {
        "Cube": "MaterialTransaction",
        "Dimensions": [
            [
                {
                    "List": [
                        "ProductName"
                    ],
                    "Name": "ProductName",
                    "Hierarchy": "H1"
                }
            ],
            [
                {
                    "List": [
                        "TransactionDateYear"
                    ],
                    "Name": "TransactionDate",
                    "Hierarchy": "H1"
                },
                {
                    "List": [
                        "TransactionDateMonth"
                    ],
                    "Name": "TransactionDate",
                    "Hierarchy": "H1"
                },
                {
                    "List": [
                        "TransactionDateDay"
                    ],
                    "Name": "TransactionDate",
                    "Hierarchy": "H1"
                }
            ]
        ],
        "Measures": [
            [
                {
                    "name": "%COUNT",
                    "caption": "カウント",
                    "type": "integer",
                    "hidden": 0,
                    "factName": ""
                },
                {
                    "name": "Quantity",
                    "caption": "Quantity",
                    "type": "number",
                    "hidden": 0,
                    "factName": "MxQuantityN"
                }
            ]
        ]
    }
]

example={
    "cube": "ABiCConsecutiveDayCube",
    "dimensions": [
        {
            "name": "EmpRole",
            "mdx": "[EmpRole].[H1].[EmpRole].Members"
        },
        {
            "name": "ShiftName",
            "mdx": "[ShiftName].[H1].[ShiftName].Members"
        },
        {
            "name": "DateOfEx",
            "mdx": "[DateOfEx].[H1].[Year].&[2024]"
        }
    ],
    "measures": [
        {
            "name": "%COUNT",
            "mdx": "[Measures].[%COUNT]"
        },
        {
            "name": "ConsecutiveDayAVG",
            "mdx": "[Measures].[ConsecutiveDayAVG]"
        },
        {
            "name": "ConsecutiveDaysMax",
            "mdx": "[Measures].[ConsecutiveDaysMax]"
        }
    ],
    "filters": {
        "mdx_where": [
            "[DateOfEx].[H1].[Year].&[2024]"
        ]
    },
    "group_by": [
        {
            "name": "EmpRole",
            "mdx": "[EmpRole].[H1].[EmpRole].Members"
        },
        {
            "name": "ShiftName",
            "mdx": "[ShiftName].[H1].[ShiftName].Members"
        }
    ]
}