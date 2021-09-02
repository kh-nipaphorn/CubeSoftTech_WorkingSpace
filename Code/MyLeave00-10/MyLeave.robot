*** Settings ***
Library    SeleniumLibrary
Library    String
Library    DateTime
Library    BuiltIn

*** Variable ***
${id_login}    test_it_roles
${id_name}    IT ROLE TESTING
${HOMEPAGE}    http://uat.cubesofttech.com/
${BROWSER}    chrome

${table}    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]
${Duration_datefrom}    xpath=//*[@id="date_from"]
${Duration_dateto}    xpath=//*[@id="date_to"]


*** Keywords ***
Employee Login Unsuccess
    Open Browser    ${HOMEPAGE}    ${BROWSER}
    Maximize Browser Window
    Title Should Be    Cube SoftTech : Login
    Wait Until Page Contains    Login to your account
    Input Text    username    ${id_login}
    Input Password    password    0000
    Click button    id=submit myBtn
    Sleep    10s
    Capture Page Screenshot    1_Login_Unsuccess.png 

Employee Login Success
    Title Should Be    Cube SoftTech : Login
    Wait Until Page Contains    Login to your account
    Input Text    username    ${id_login}
    Input Password    password    1234
    Click button    id=submit myBtn
    Title Should Be    check in
    Wait Until Page Contains    Welcome
    Page Should Contain    ${id_login}
    Sleep    15s
    Capture Page Screenshot    2_Login_Success.png

Click MyLeave Button
    Click Element    xpath://*[@href="myleave_list?Id=test_it_roles"]
    Title Should Be    My leave list
    
Click Add Leave
    Click button    addLeave
    Title Should Be    Add Leave


*** Test Case ***

TC-LEAVE-EMP-001 N_Login_Unsuccess
    Employee Login Unsuccess
    Log To Console    This Test Case Is Pass

TC-LEAVE-EMP-002 P_Login_Success
    Employee Login Success
    Log To Console    This Test Case Is Pass

TC-LEAVE-EMP-003 P_Add_Vacation_Leave
    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${id_name}
    
    # Select Type of leave >>> ลากิจ ลาพักร้อน
    Click Element    xpath=//*[@id="leaveTypes"]/label[1]
    Radio Button Should Be Set To    leaveType    1
    
    # Select Duration
    # select start date >>> 19-08-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[4]/td[5]    # select date

    # select start date >>> 20-08-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[4]/td[6]    # select date

    # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '19-08-''${year}' and '${check_dateTo}' == '20-08-''${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '2'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-003
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-003'
    
    # Input & Check Reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    Click MyLeave Button

    # Check data from table

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลากิจ/ลาพักร้อน'

    # Start date (Since)
    ${check_StartDate}=    Get Table Cell    ${table}    1    5
    ${check_StartDate_data}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate}' == 'Start date (Since)' and '${check_StartDate_data}' == '${check_dateFrom}'

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate}' == 'End date (Until)' and '${check_EndDate_data}' == '${check_dateTo}'

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' == '${check_amount}.000'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    10s
    Capture Page Screenshot    3_Add_Vacation_Leave.png
    Log To Console    This Test Case Is Pass


TC-LEAVE-EMP-004 P_Add_Vacation_From_Last_Year_Leave
    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${id_name}
    
    # Select Type of leave >>> ลาพักร้อนที่เหลือจากปีก่อน
    Click Element    xpath=//*[@id="leaveTypes"]/label[5]
    Radio Button Should Be Set To    leaveType    6
    
    # Select Duration
    # select start date >>> 25-08-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[5]/td[4]    # select date

    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]

    # select start date >>> 25-08-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    # Wait Until Page Should Be Contains    August 2021
    # Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[5]/td[4]    # select date

    # # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    
    ${Fail}=    Run Keyword And Return Status    Wait Until Page Should Be Contains    August 2021
    Run Keyword Unless    ${Fail}    Log To Console    The step ${Fail}! 

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '1'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-004
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-004'
    
    # Input & Check Reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]
    Wait Until Page Does Not Contain    Pleace fill out this field.
    Capture Page Screenshot    4_1_Add_Vacation_From_Last_Year_Leave.png
    Click MyLeave Button

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' != 'ลาพักร้อนที่เหลือจากปีก่อน'

    # Start date (Since)
    ${check_StartDate}=    Get Table Cell    ${table}    1    5
    ${check_StartDate_data}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate}' == 'Start date (Since)' and '${check_StartDate_data}' != '${check_dateFrom}'

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate}' == 'End date (Until)' and '${check_EndDate_data}' != '${check_dateTo}'

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' != '${check_amount}.000'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    10s
    Capture Page Screenshot    4_2_Add_Vacation_From_Last_Year_Leave.png
    Log To Console    This Test Case Is Not Pass

TC-LEAVE-EMP-005 P_Add_Sick_Leave
    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${id_name}
    
    # Select Type of leave >>> ลาป่วย
    Click Element    xpath=//*[@id="leaveTypes"]/label[3]
    Radio Button Should Be Set To    leaveType    3
    
    # Select Duration
    # select start date >>> 27-08-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[5]/td[6]    # select date

    # select start date >>> 27-08-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[5]/td[6]    # select date

    # # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '27-08-''${year}' and '${check_dateTo}' == '27-08-''${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '1'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-005
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-005'
    
    # Input & Check Reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    Click MyLeave Button

    # Check data from table

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลาป่วย'

    # Start date (Since)
    ${check_StartDate}=    Get Table Cell    ${table}    1    5
    ${check_StartDate_data}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate}' == 'Start date (Since)' and '${check_StartDate_data}' == '${check_dateFrom}'

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate}' == 'End date (Until)' and '${check_EndDate_data}' == '${check_dateTo}'

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' == '${check_amount}.000'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    10s
    Capture Page Screenshot    5_Add_Sick_Leave.png
    Log To Console    This Test Case Is Pass

TC-LEAVE-EMP-006 P_Add_Other_Types_Of_Leave
    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${id_name}
    
    # Select Type of leave >>> ลาอื่นๆ
    Click Element    xpath=//*[@id="leaveTypes"]/label[2]
    Radio Button Should Be Set To    leaveType    2
    
    # Select Duration
    # select start date >>> 01-09-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]   # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[4]    # select date

    # select start date >>> 01-09-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]   # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[4]    # select date

    # # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '01-09-''${year}' and '${check_dateTo}' == '01-09-''${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '1'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-006
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-006'
    
    # Input & Check Reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    Click MyLeave Button

    # Check data from table

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลาอื่นๆ'

    # Start date (Since)
    ${check_StartDate}=    Get Table Cell    ${table}    1    5
    ${check_StartDate_data}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate}' == 'Start date (Since)' and '${check_StartDate_data}' == '${check_dateFrom}'

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate}' == 'End date (Until)' and '${check_EndDate_data}' == '${check_dateTo}'

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' == '${check_amount}.000'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    10s
    Capture Page Screenshot    6_Add_Other_Types_Of_Leave.png
    Log To Console    This Test Case Is Pass

TC-LEAVE-EMP-007 P_Add_Unpaid_Leave
    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${id_name}
    
    # Select Type of leave >>> ลาโดยไม่รับค่าจ้าง
    Click Element    xpath=//*[@id="leaveTypes"]/label[4]
    Radio Button Should Be Set To    leaveType    5
    
    # Select Duration
    # select start date >>> 02-09-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[5]    # select date

    # select start date >>> 06-09-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '02-09-''${year}' and '${check_dateTo}' == '06-09-''${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '3'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-007
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-007'
    
    # Input & Check Reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    Click MyLeave Button

    # Check data from table

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลาโดยไม่รับค่าจ้าง'

    # Start date (Since)
    ${check_StartDate}=    Get Table Cell    ${table}    1    5
    ${check_StartDate_data}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate}' == 'Start date (Since)' and '${check_StartDate_data}' == '${check_dateFrom}'

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate}' == 'End date (Until)' and '${check_EndDate_data}' == '${check_dateTo}'

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' == '${check_amount}.000'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    10s
    Capture Page Screenshot    7_Add_Unpaid_Leave.png
    Log To Console    This Test Case Is Pass

TC-LEAVE-EMP-008 N_Add_Leave_But_Not_Select_Type_Of_Leave
    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${id_name}
    
    # Select Duration
    # select start date >>> 31-08-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[6]/td[3]    # select date

    # select start date >>> 31-08-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[6]/td[3]    # select date

    # # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '31-08-''${year}' and '${check_dateTo}' == '31-08-''${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '1'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-008
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-008'
    
    # Input & Check Reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]
    Wait Until Page Does Not Contain    Pleace select one of these option.
    Capture Page Screenshot    8_1_Add_Leave_But_Not_Select_Type_Of_Leave.png

    Click MyLeave Button

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' != ''

    # Start date (Since)
    ${check_StartDate}=    Get Table Cell    ${table}    1    5
    ${check_StartDate_data}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate}' == 'Start date (Since)' and '${check_StartDate_data}' != '${check_dateFrom}'

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate}' == 'End date (Until)' and '${check_EndDate_data}' != '${check_dateTo}'

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' != ''

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    10s
    Capture Page Screenshot    8_2_Add_Leave_But_Not_Select_Type_Of_Leave.png
    Log To Console    This Test Case Is Pass

TC-LEAVE-EMP-009 P_Add_Retroactive_Vacation_Leave
    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${id_name}
    
    # Select Type of leave >>> ลากิจ ลาพักร้อน
    Click Element    xpath=//*[@id="leaveTypes"]/label[1]
    Radio Button Should Be Set To    leaveType    1
    
    # Select Duration
    # select start date >>> 02-08-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # select start date >>> 02-08-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '02-08-${year}' and '${check_dateTo}' == '02-08-${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '1'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-009
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-009'
    
    # Input & Check Reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    Click MyLeave Button

    # Check data from table

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลากิจ/ลาพักร้อน'

    # Start date (Since)
    ${check_StartDate}=    Get Table Cell    ${table}    1    5
    ${check_StartDate_data}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate}' == 'Start date (Since)' and '${check_StartDate_data}' == '${check_dateFrom}'

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate}' == 'End date (Until)' and '${check_EndDate_data}' == '${check_dateTo}'

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' == '${check_amount}.000'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    10s
    Capture Page Screenshot    9_Add_Retroactive_Vacation_Leave.png
    Log To Console    This Test Case Is Pass

TC-LEAVE-EMP-010 P_Add_Vacation_Leave_Complete_The_Quota
    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${id_name}
    
    # Select Type of leave >>> ลากิจ ลาพักร้อน
    Click Element    xpath=//*[@id="leaveTypes"]/label[1]
    Radio Button Should Be Set To    leaveType    1
    
    # Select Duration
    # select start date >>> 13-09-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[3]/td[2]    # select date

    # select start date >>> 24-09-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[4]/td[6]    # select date

    # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '13-09-''${year}' and '${check_dateTo}' == '24-09-''${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '10'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-010
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-010'
    
    # Input & Check Reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    Click MyLeave Button

    # Check data from table

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลากิจ/ลาพักร้อน'

    # Start date (Since)
    ${check_StartDate}=    Get Table Cell    ${table}    1    5
    ${check_StartDate_data}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate}' == 'Start date (Since)' and '${check_StartDate_data}' == '${check_dateFrom}'

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate}' == 'End date (Until)' and '${check_EndDate_data}' == '${check_dateTo}'

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' == '${check_amount}.000'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    10s
    Capture Page Screenshot    10_Add_Vacation_Leave_Complete_The_Quota.png
    Log To Console    This Test Case Is Pass

TC-LEAVE-EMP-011 P_Add_Vacation_From_Last_Year_Leave_to_Complete_The_Quota
    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${id_name}
    
    # Select Type of leave >>> ลาพักร้อนที่เหลือจากปีก่อน
    Click Element    xpath=//*[@id="leaveTypes"]/label[5]
    Radio Button Should Be Set To    leaveType    6
    
    # Select Duration
    # select start date >>> 05-10-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[10]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[3]    # select date

    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]

    # select start date >>> 05-10-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[10]    # select mont

    # # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${Fail}=    Run Keyword And Return Status    Wait Until Page Should Be Contains    October 2021
    Run Keyword Unless    ${Fail}    Log To Console    The step ${Fail}! 

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '1'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-011
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-011'
    
    # Input & Check Reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]
    Wait Until Page Does Not Contain    Pleace fill out this field.
    Capture Page Screenshot    11_1_Add_Vacation_From_Last_Year_Leave_to_Complete_The_Quota.png
    Click MyLeave Button

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' != 'ลาพักร้อนที่เหลือจากปีก่อน'

    # Start date (Since)
    ${check_StartDate}=    Get Table Cell    ${table}    1    5
    ${check_StartDate_data}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate}' == 'Start date (Since)' and '${check_StartDate_data}' != '${check_dateFrom}'

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate}' == 'End date (Until)' and '${check_EndDate_data}' != '${check_dateTo}'

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' != '${check_amount}.000'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    10s
    Capture Page Screenshot    11_2_Add_Vacation_From_Last_Year_Leave_to_Complete_The_Quota.png
    Log To Console    This Test Case Is Not Pass

TC-LEAVE-EMP-012 P_Add_Vacation_From_The_Previous_Year_Quota_Exceeded
    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${id_name}
    
    # Select Type of leave >>> ลากิจ ลาพักร้อน
    Click Element    xpath=//*[@id="leaveTypes"]/label[1]
    Radio Button Should Be Set To    leaveType    1
    
    # Select Duration
    # select start date >>> 01-11-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[11]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[2]    # select date

    # select start date >>> 16-11-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[11]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[3]/td[3]    # select date

    # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '01-11-''${year}' and '${check_dateTo}' == '16-11-''${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '12'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-012
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-012'
    
    # Input & Check Reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]
    ${Fail}=    Run Keyword And Return Status    Handle Alert 	timeout=5s
    Run Keyword Unless    ${Fail}    Log To Console    The step ${Fail}!

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    Click MyLeave Button

    # Check data from table

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลากิจ/ลาพักร้อน'

    # Start date (Since)
    ${check_StartDate}=    Get Table Cell    ${table}    1    5
    ${check_StartDate_data}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate}' == 'Start date (Since)' and '${check_StartDate_data}' == '${check_dateFrom}'

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate}' == 'End date (Until)' and '${check_EndDate_data}' == '${check_dateTo}'

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' == '${check_amount}.000'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    10s
    Capture Page Screenshot    12_Add_Vacation_From_The_Previous_Year_Quota_Exceeded.png
    Log To Console    This Test Case Is Not Pass

TC-LEAVE-EMP-013 P_Add_Vacation_From_Last_Year_Quota_Exceeded
    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${id_name}
    
    # Select Type of leave >>> ลาพักร้อนที่เหลือจากปีก่อน
    Click Element    xpath=//*[@id="leaveTypes"]/label[5]
    Radio Button Should Be Set To    leaveType    6
    
    # Select Duration
    # select start date >>> 23-11-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[11]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[4]/td[3]    # select date

    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]

    # select start date >>> 25-11-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[11]    # select mont

    # # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${Fail}=    Run Keyword And Return Status    Wait Until Page Should Be Contains    Novenber 2021
    Run Keyword Unless    ${Fail}    Log To Console    The step ${Fail}! 

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' != '2'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-013
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-013'
    
    # Input & Check Reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]
    Wait Until Page Does Not Contain    Pleace fill out this field.
    Capture Page Screenshot    13_1_Add_Vacation_From_Last_Year_Quota_Exceeded.png
    Click MyLeave Button

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' != 'ลาพักร้อนที่เหลือจากปีก่อน'

    # Start date (Since)
    ${check_StartDate}=    Get Table Cell    ${table}    1    5
    ${check_StartDate_data}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate}' == 'Start date (Since)' and '${check_StartDate_data}' != '${check_dateFrom}'

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate}' == 'End date (Until)' and '${check_EndDate_data}' != '${check_dateTo}'

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' != '${check_amount}.000'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    10s
    Capture Page Screenshot    13_2_Add_Vacation_From_Last_Year_Quota_Exceeded.png
    Log To Console    This Test Case Is Not Pass

TC-LEAVE-EMP-014 N_Add_Leave_On_Weekends_Success
    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${id_name}
    
    # Select Type of leave >>> ลากิจ ลาพักร้อน
    Click Element    xpath=//*[@id="leaveTypes"]/label[1]
    Radio Button Should Be Set To    leaveType    1
    
    # Select Duration
    # select start date >>> 28-08-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[5]/td[7]    # select date
    ${year}    Get Current Date    result_format=%Y

    # Check select start date
    ${Fail}=    Run Keyword And Return Status    Wait Until Page Should Be Contains    28-08-'${year}'
    Run Keyword Unless    ${Fail}    Log To Console    The step ${Fail}!

    # select start date >>> 29-08-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[6]/td[1]    # select date

    # Check select end date
    ${Fail}=    Run Keyword And Return Status    Wait Until Page Should Be Contains    29-08-'${year}'
    Run Keyword Unless    ${Fail}    Log To Console    The step ${Fail}!


    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' != '2'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-014
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-014'
    
    # Input & Check Reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]
    Wait Until Page Does Not Contain    Pleace fill out this field.
    Capture Page Screenshot    14_1_Add_Leave_On_Weekends_Success.png
    Click MyLeave Button

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' != ''

    # Start date (Since)
    ${check_StartDate}=    Get Table Cell    ${table}    1    5
    ${check_StartDate_data}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate}' == 'Start date (Since)' and '${check_StartDate_data}' != '28-08-''${year}'

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate}' == 'End date (Until)' and '${check_EndDate_data}' != '29-08-''${year}'

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' != '${check_amount}.000'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    10s
    Capture Page Screenshot    14_2_Add_Leave_On_Weekends_Success.png
    Log To Console    This Test Case Is Not Pass

TC-LEAVE-EMP-015 P_Add_Leave_On_Weekends_Unsuccess
    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${id_name}
    
    # Select Type of leave >>> ลากิจ ลาพักร้อน
    Click Element    xpath=//*[@id="leaveTypes"]/label[1]
    Radio Button Should Be Set To    leaveType    1
    
    # Select Duration
    # select start date >>> 28-08-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[5]/td[7]    # select date
    ${year}    Get Current Date    result_format=%Y

    # Check select start date
    ${Fail}=    Run Keyword And Return Status    Wait Until Page Should Be Contains    28-08-'${year}'
    Run Keyword Unless    ${Fail}    Log To Console    The step ${Fail}!

    # select start date >>> 29-08-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[6]/td[1]    # select date

    # Check select end date
    ${Fail}=    Run Keyword And Return Status    Wait Until Page Should Be Contains    29-08-'${year}'
    Run Keyword Unless    ${Fail}    Log To Console    The step ${Fail}!


    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' != '2'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-015
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-015'
    
    # Input & Check Reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]
    Wait Until Page Does Not Contain    Pleace fill out this field.
    Capture Page Screenshot    15_1_Add_Leave_On_Weekends.png
    Click MyLeave Button

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' != ''

    # Start date (Since)
    ${check_StartDate}=    Get Table Cell    ${table}    1    5
    ${check_StartDate_data}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate}' == 'Start date (Since)' and '${check_StartDate_data}' != '28-08-''${year}'

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate}' == 'End date (Until)' and '${check_EndDate_data}' != '29-08-''${year}'

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' != '${check_amount}.000'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    10s
    Capture Page Screenshot    15_2_Add_Leave_On_Weekends.png
    Log To Console    This Test Case Is Pass

TC-LEAVE-EMP-016 N_Add_Public_Holidays
    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${id_name}
    
    # Select Type of leave >>> ลากิจ ลาพักร้อน
    Click Element    xpath=//*[@id="leaveTypes"]/label[1]
    Radio Button Should Be Set To    leaveType    1
    
    # Select Duration
    # select start date >>> 13-10-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[10]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[3]/td[4]    # select date
    ${year}    Get Current Date    result_format=%Y

    # Check select start date
    ${Fail}=    Run Keyword And Return Status    Wait Until Page Should Be Contains    13-10-'${year}'
    Run Keyword Unless    ${Fail}    Log To Console    The step ${Fail}!

    # select start date >>> 13-10-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[10]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[3]/td[4]    # select date

    # Check select end date
    ${Fail}=    Run Keyword And Return Status    Wait Until Page Should Be Contains    13-10-'${year}'
    Run Keyword Unless    ${Fail}    Log To Console    The step ${Fail}!


    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '1'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-016
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-016'
    
    # Input & Check Reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]
    Wait Until Page Does Not Contain    Pleace fill out this field.
    Capture Page Screenshot    16_1_Add_Public_Holidays.png
    Click MyLeave Button

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' != ''

    # Start date (Since)
    ${check_StartDate}=    Get Table Cell    ${table}    1    5
    ${check_StartDate_data}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate}' == 'Start date (Since)' and '${check_StartDate_data}' != '13-10-''${year}'

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate}' == 'End date (Until)' and '${check_EndDate_data}' != '13-10-''${year}'

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' or '${check_AmountOfTheDay_data}' != '${check_amount}.000'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    10s
    Capture Page Screenshot    15_2_Add_Public_Holidays.png
    Log To Console    This Test Case Is Not Pass

TC-LEAVE-EMP-017 P_Add_Public_Holidays
    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${id_name}
    
    # Select Type of leave >>> ลากิจ ลาพักร้อน
    Click Element    xpath=//*[@id="leaveTypes"]/label[1]
    Radio Button Should Be Set To    leaveType    1
    
    # Select Duration
    # select start date >>> 13-10-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[10]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[3]/td[4]    # select date
    ${year}    Get Current Date    result_format=%Y

    # Check select start date
    ${Fail}=    Run Keyword And Return Status    Wait Until Page Should Be Contains    13-10-'${year}'
    Run Keyword Unless    ${Fail}    Log To Console    The step ${Fail}!

    # select start date >>> 13-10-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[10]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[3]/td[4]    # select date

    # Check select end date
    ${Fail}=    Run Keyword And Return Status    Wait Until Page Should Be Contains    13-10-'${year}'
    Run Keyword Unless    ${Fail}    Log To Console    The step ${Fail}!


    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '1'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-017
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-017'
    
    # Input & Check Reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]
    Wait Until Page Does Not Contain    Pleace fill out this field.
    Capture Page Screenshot    17_1_Add_Public_Holidays.png
    Click MyLeave Button

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' != ''

    # Start date (Since)
    ${check_StartDate}=    Get Table Cell    ${table}    1    5
    ${check_StartDate_data}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate}' == 'Start date (Since)' and '${check_StartDate_data}' != '13-10-''${year}'

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate}' == 'End date (Until)' and '${check_EndDate_data}' != '13-10-''${year}'

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' or '${check_AmountOfTheDay_data}' != '${check_amount}.000'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    10s
    Capture Page Screenshot    17_2_Add_Public_Holidays.png
    Log To Console    This Test Case Is Pass

TC-LEAVE-EMP-018 P_Add_Next_Year_Leave

    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${id_name}
    
    # Select Type of leave >>> ลาอื่นๆ
    Click Element    xpath=//*[@id="leaveTypes"]/label[2]
    Radio Button Should Be Set To    leaveType    2
    
    # Select Duration
    # select start date >>> 11-01-2022
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select year
    Click Element    xpath=/html/body/div[5]/div[2]/table/thead/tr[2]/th[3]    # select next year
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[1]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[3]/td[3]    # select date

    # select start date >>> 12-01-2022
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[3]/td[4]    # select date

    # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    Should Be True    '${check_dateFrom}' == '11-01-2022' and '${check_dateTo}' == '12-01-2022'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '2'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-018
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-018'
    
    # Input & Check Reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    Click MyLeave Button

    # Check data from table

    # Search data start
    Click Element    xpath=/html/body/div[3]/div[2]/div[1]/div[2]/div[2]/form/div/div[1]/div[2]/div[2]/div/div/input[1]  # select for change year
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for change year
    Click Element    xpath=/html/body/div[4]/div[2]/table/thead/tr[2]/th[3]    # click next year
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[1]   # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[1]/td[7]    # select day

    # Search data end
    Click Element    xpath=/html/body/div[3]/div[2]/div[1]/div[2]/div[2]/form/div/div[1]/div[2]/div[2]/div/div/input[2]  # select for change year
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for change year
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[12]   # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[5]/td[7]    # select day

    Click Element    xpath=//*[@id="search"]

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลาอื่นๆ'

    # Start date (Since)
    ${check_StartDate}=    Get Table Cell    ${table}    1    5
    ${check_StartDate_data}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate}' == 'Start date (Since)' and '${check_StartDate_data}' == '${check_dateFrom}'

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate}' == 'End date (Until)' and '${check_EndDate_data}' == '${check_dateTo}'

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' == '${check_amount}.000'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    10s
    Capture Page Screenshot    18_Add_Next_Year_Leave.png
    Log To Console    This Test Case Is Pass

TC-LEAVE-EMP-019 P_Add_Last_Year_Leave

    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${id_name}
    
    # Select Type of leave >>> ลาอื่นๆ
    Click Element    xpath=//*[@id="leaveTypes"]/label[2]
    Radio Button Should Be Set To    leaveType    2
    
    # Select Duration
    # select start date >>>  03-12-2020
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select year
    Click Element    xpath=/html/body/div[5]/div[2]/table/thead/tr[2]/th[1]    # select last year
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[12]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[5]    # select date

    # select start date >>>  03-12-2020
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[5]    # select date

    # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    Should Be True    '${check_dateFrom}' == '03-12-2020' and '${check_dateTo}' == '03-12-2020'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '1'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-019
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-019'
    
    # Input & Check Reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    Click MyLeave Button

    # Check data from table

    # Search data start
    Click Element    xpath=/html/body/div[3]/div[2]/div[1]/div[2]/div[2]/form/div/div[1]/div[2]/div[2]/div/div/input[1]  # select for change year
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for change year
    Click Element    xpath=/html/body/div[4]/div[2]/table/thead/tr[2]/th[1]    # click last year
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[1]   # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[1]/td[4]    # select day

    # Search data end
    Click Element    xpath=/html/body/div[3]/div[2]/div[1]/div[2]/div[2]/form/div/div[1]/div[2]/div[2]/div/div/input[2]  # select for change year
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for change year
    Click Element    xpath=/html/body/div[4]/div[2]/table/thead/tr[2]/th[1]    # click last year
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[12]   # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[5]/td[5]    # select day

    Click Element    xpath=//*[@id="search"]

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลาอื่นๆ'

    # Start date (Since)
    ${check_StartDate}=    Get Table Cell    ${table}    1    5
    ${check_StartDate_data}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate}' == 'Start date (Since)' and '${check_StartDate_data}' == '${check_dateFrom}'

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate}' == 'End date (Until)' and '${check_EndDate_data}' == '${check_dateTo}'

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' == '${check_amount}.000'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    10s
    Capture Page Screenshot    19_Add_Last_Year_Leave.png
    Log To Console    This Test Case Is Pass

TC-LEAVE-EMP-020 P_Add_Half_Of_Day_Leave

    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${id_name}
    
    # Select Type of leave >>> ลาอื่นๆ
    Click Element    xpath=//*[@id="leaveTypes"]/label[2]
    Radio Button Should Be Set To    leaveType    2
    
    # Select Duration
    # select start date >>>  03-09-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select this for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[6]    # select date

    # select start date >>>  06-09-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select this for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '03-09-''${year}' and '${check_dateTo}' == '06-09-''${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '2'

    # Input & Check Hours
    Click Element    xpath=//*[@id="amount_sub"]
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div[3]/div[2]/select/option[4]
    ${check_hour}    Get Text    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div[3]/div[2]/select/option[4]
    Should Be True    '${check_hour}' == '3'

    # input & check half of day leave
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div[4]/div/div/label[1]   # Morning
    # Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div[4]/div/div/label[1]   # Afternoon
    Radio Button Should Be Set To    halfDay    1

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-020
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-020'
    
    # Input & Check Reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    Click MyLeave Button

    # Check data from table

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลาอื่นๆ'

    # Start date (Since)
    ${check_StartDate}=    Get Table Cell    ${table}    1    5
    ${check_StartDate_data}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate}' == 'Start date (Since)' and '${check_StartDate_data}' == '${check_dateFrom}'

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate}' == 'End date (Until)' and '${check_EndDate_data}' == '${check_dateTo}'

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    ${split}=    Remove String    ${check_AmountOfTheDay_data}    ${check_amount}
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' == '${check_amount}${split}'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    10s
    Capture Page Screenshot    3_Add_Vacation_Leave.png
    Log To Console    This Test Case Is Pass

    Close All Browsers