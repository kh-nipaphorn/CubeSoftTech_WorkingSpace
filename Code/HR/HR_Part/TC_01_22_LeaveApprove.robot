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
${hr_name}    วีระวัฒน์ ภูมิพัฒนพงศ์
${HOMEPAGE}    http://uat.cubesofttech.com/
${BROWSER}    chrome

${table}    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]
${table_body}    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr
${Duration_datefrom}    xpath=//*[@id="date_from"]
${Duration_dateto}    xpath=//*[@id="date_to"]

*** Keywords ***
Employee Login Success
    Title Should Be    Cube SoftTech : Login
    Wait Until Page Contains    Login to your account
    Input Text    username    ${it_login}
    Input Password    password    1234
    Click button    id=submit myBtn
    Title Should Be    check in
    Wait Until Page Contains    Welcome
    Page Should Contain    ${it_login}
    Sleep    5s
Employee Login Unsuccess
    Open Browser    ${HOMEPAGE}    ${BROWSER}
    Maximize Browser Window
    Title Should Be    Cube SoftTech : Login
    Wait Until Page Contains    Login to your account
    Input Text    username    ${it_login}
    Input Password    password    0000
    Click button    id=submit myBtn
    Title Should Be    Cube SoftTech : Login
    Sleep    5s
Click MyLeave Button
    Click Element    xpath://*[@href="myleave_list?Id=${it_login}"]
    Title Should Be    My leave list
Click Add Leave
    Click button    addLeave
    Title Should Be    Add Leave

*** Test Case ***

TC-LEAVE-HR-001 Login_Unsuccess
    Employee Login Unsuccess
    Log To Console    Login Unsucces Pass

TC-LEAVE-HR-002 Login_Success
    Employee Login Success
    Log To Console    Login Succes Pass

TC-LEAVE-HR-003 Add_select_Applicant
    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${it_name}

    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div[1]/div[1]/div/span/span[1]/span
    Press Keys    xpath=//*[@class="select2-search__field"]    ${it_name}    ENTER
    Capture Page Screenshot    3_1_Before_Select_Applicant.png

    # Select Type of leave >>> ลากิจ ลาพักร้อน
    Click Element    xpath=//*[@id="leaveTypes"]/label[1]
    Radio Button Should Be Set To    leaveType    1

    # Select Duration
    # select start date >>> 02-08-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # select end date >>> 02-08-2021
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
    Input Text    id=description    TC-LEAVE-003
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-003'
    
    # Input & Check Reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="approver"]/option[5]
    Should Be True    "${check_approver}" == "${hr_name}"

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    Click MyLeave Button

    ${count_table}= 	Get Element Count 	${table_body}

    # Check Applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    ${count_table}    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == '${it_login}'

    Capture Page Screenshot    3_2_After_Select_Applicant.png

    Log To Console    This Test Case Is Pass

TC-LEAVE-HR-004