*** Settings ***
Library    SeleniumLibrary
Library    String
Library    DateTime
Library    BuiltIn

*** Variable ***
# ${it_login}    test_it_roles
# ${it_name}    IT ROLE TESTING
${it_login}    test_hr_role
${it_name}    HR Role Testing
${HOMEPAGE}    http://uat.cubesofttech.com/
${BROWSER}    chrome

${table}    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]
${Duration_datefrom}    xpath=//*[@id="date_from"]
${Duration_dateto}    xpath=//*[@id="date_to"]

*** Keywords ***
Employee Login Success
    Open Browser    ${HOMEPAGE}    ${BROWSER}
    Maximize Browser Window
    Title Should Be    Cube SoftTech : Login
    Wait Until Page Contains    Login to your account
    Input Text    username    ${it_login}
    Input Password    password    1234
    Click button    id=submit myBtn
    Title Should Be    check in
    Wait Until Page Contains    Welcome
    Page Should Contain    ${it_login}
    Sleep    5s

IT Click MyLeave Button
    Click Element    xpath://*[@href="myleave_list?Id=${it_login}"]
    Title Should Be    My leave list
    
Click Add Leave
    Click button    addLeave
    Title Should Be    Add Leave

*** Test Case ***

Login_Success
    Employee Login Success
    Log To Console    Login Pass

TC-LEAVE-EMP-043 N_Delete_Success

    IT Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${it_name}

    # Select Type of leave >>> ลาอื่นๆ
    Click Element    xpath=//*[@id="leaveTypes"]/label[2]
    Radio Button Should Be Set To    leaveType    2
    
    # Select Duration
    # select start date >>> 08-09-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[4]    # select date

    # select end date >>> 08-09-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[4]    # select date

    # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '08-09-''${year}' and '${check_dateTo}' == '08-09-''${year}'

    #input $ Check amount
    Input Text    id=amount    1

    # Input & Check Description
    Input Text    id=description    Delete
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'Delete'

    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    IT Click MyLeave Button
    
    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID'

    Capture Page Screenshot    43_1_BeforeDelete.png

    #------------------------------ Delete Part --------------------------------------------------#

    # Click Calendar Button
    Click Element    xpath=/html/body/div[3]/div[1]/div/ul/li[2]/a
    # Click Check All Calendar
    Click Element    xpath=/html/body/div[3]/div[1]/div/ul/li[2]/ul/li/a
    Title Should be    Check All Calendar
    Sleep    5s

    # Click for delete
    ${Fail}=    Run Keyword And Return Status    Wait Until Element Is Not Visible    xpath=/html/body/div[3]/div[2]/div/div[2]/form/div/div[2]/div/div/div[2]/div/div[1]/div/div[2]/div/table/tbody/tr/td/div/div/div[2]/div[2]/table/tbody/tr[1]/td[3]/a/div/span[2]/i
    Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!
    # ---------------------- Re check ----------------------------#
    
    IT Click MyLeave Button
    ${check_LeaveS_ID_data2}=    Get Table Cell    ${table}    2    1

    ${Fail}=    Run Keyword And Return Status    Should Be True    '${check_LeaveS_ID_data}' != '${check_LeaveS_ID_data2}'
    Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!

    # Should Be True    '${check_LeaveS_ID_data}' != '${check_LeaveS_ID_data2}'

    Capture Page Screenshot    43_2_AfterDelete.png

    Log To Console    This Test Case Is False

TC-LEAVE-EMP-044 P_Delete_UnSccess

    IT Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${it_name}

    # Select Type of leave >>> ลาอื่นๆ
    Click Element    xpath=//*[@id="leaveTypes"]/label[2]
    Radio Button Should Be Set To    leaveType    2
    
    # Select Duration
    # select start date >>> 08-09-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[4]    # select date

    # select end date >>> 08-09-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[4]    # select date

    # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '08-09-''${year}' and '${check_dateTo}' == '08-09-''${year}'

    #input $ Check amount
    Input Text    id=amount    1

    # Input & Check Description
    Input Text    id=description    Delete
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'Delete'

    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    IT Click MyLeave Button
    
    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID'

    Capture Page Screenshot    44_1_BeforeDelete.png

    #------------------------------ Delete Part --------------------------------------------------#

    # Click Calendar Button
    Click Element    xpath=/html/body/div[3]/div[1]/div/ul/li[2]/a
    # Click Check All Calendar
    Click Element    xpath=/html/body/div[3]/div[1]/div/ul/li[2]/ul/li/a
    Title Should be    Check All Calendar
    Sleep    5s

    # Click for delete
    ${Fail}=    Run Keyword And Return Status    Wait Until Element Is Not Visible    xpath=/html/body/div[3]/div[2]/div/div[2]/form/div/div[2]/div/div/div[2]/div/div[1]/div/div[2]/div/table/tbody/tr/td/div/div/div[2]/div[2]/table/tbody/tr[1]/td[3]/a/div/span[2]/i
    Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!

    Sleep    5s

    # ---------------------- Re check ----------------------------#
    
    IT Click MyLeave Button

    ${check_LeaveS_ID_data2}=    Get Table Cell    ${table}    2    1
    
    ${Fail}=    Run Keyword And Return Status    Should Be True    '${check_LeaveS_ID_data}' == '${check_LeaveS_ID_data2}'
    Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!
    
    Capture Page Screenshot    44_2_AfterDelete.png

    Log To Console    This Test Case Is False

TC-LEAVE-EMP-045 Forget_Input_TypeOfDayLeave

    IT Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${it_name}
    
    # Select Duration
    # select start date >>> 08-09-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[4]    # select date

    # select end date >>> 08-09-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[4]    # select date

    # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '08-09-''${year}' and '${check_dateTo}' == '08-09-''${year}'

    #input $ Check amount
    Input Text    id=amount    1

    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]
    Wait Until Page Does Not Contain    Please select one of these options.
    Sleep    3s
    Log To Console    This Test Case Is Pass
    Capture Page Screenshot    45_TypeOfDayLeave.png

TC-LEAVE-EMP-046 Forget_Input_Duration

    IT Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${it_name}

    # Select Type of leave >>> ลาอื่นๆ
    Click Element    xpath=//*[@id="leaveTypes"]/label[2]
    Radio Button Should Be Set To    leaveType    2

    #input $ Check amount
    Input Text    id=amount    1

    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]
    Wait Until Page Does Not Contain    Please fill out this field.
    Sleep    3s
    Log To Console    This Test Case Is Pass
    Capture Page Screenshot    46_Duration.png

TC-LEAVE-EMP-047 Forget_Input_HalfDayLeave

    IT Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${it_name}

    # Select Type of leave >>> ลาโดยไม่รับค่าจ้าง
    Click Element    xpath=//*[@id="leaveTypes"]/label[4]
    Radio Button Should Be Set To    leaveType    5
    
    # Select Duration
    # select start date >>> 08-09-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[4]    # select date

    # select end date >>> 08-09-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[4]    # select date

    # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '08-09-''${year}' and '${check_dateTo}' == '08-09-''${year}'

    #input $ Check amount
    Input Text    id=amount    1

    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    Log To Console    This Test Case Is Pass
    Capture Page Screenshot    47_HalfDayLeave.png

TC-LEAVE-EMP-048 Forget_Input_Description
    
    IT Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${it_name}

    # Select Type of leave >>> ลาอื่นๆ
    Click Element    xpath=//*[@id="leaveTypes"]/label[2]
    Radio Button Should Be Set To    leaveType    2
    
    # Select Duration
    # select start date >>> 08-09-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[4]    # select date

    # select end date >>> 08-09-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[4]    # select date

    #input $ Check amount
    Input Text    id=amount    1

    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบการแจ้งเตือน

    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    Log To Console    This Test Case Is Pass
    Capture Page Screenshot    48_Description.png

TC-LEAVE-EMP-049 Forget_Input_Reason
    
    IT Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${it_name}

    # Select Type of leave >>> ลาป่วย
    Click Element    xpath=//*[@id="leaveTypes"]/label[3]
    Radio Button Should Be Set To    leaveType    3
    
    # Select Duration
    # select start date >>> 08-09-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[4]    # select date

    # select end date >>> 08-09-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[4]    # select date

    #input $ Check amount
    Input Text    id=amount    1

    Input Text    id=description    TC-LEAVE-049

    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    Log To Console    This Test Case Is Pass
    Capture Page Screenshot    49_Reason.png

TC-LEAVE-EMP-050 Forget_Input_All
    
    IT Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${it_name}

    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]
    Wait Until Page Does Not Contain    Please select one of these options.
    Sleep    3s
    Log To Console    This Test Case Is Pass
    Capture Page Screenshot    50_All.png

TC-LEAVE-EMP-051 Input_Duration_By_Keyboard
    
    IT Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${it_name}

    Input Text    id=date_from    08-09-2021
    Input Text    id=date_to    08-09-2021

    # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]

    ${Fail}=    Run Keyword And Return Status    Should Be True    '${check_dateFrom}' == '08-09-2021' and '${check_dateTo}' == '08-09-2021'
    Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!

    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]
    Wait Until Page Does Not Contain    Please select one of these options.
    Sleep    3s
    Log To Console    This Test Case Is False
    Capture Page Screenshot    50_All.png

    Close All Browsers
    