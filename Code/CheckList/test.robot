*** Settings ***
Library    SeleniumLibrary
Library    String
Library    DateTime
Library    BuiltIn
Library    DatabaseLibrary
Library    OperatingSystem

*** Variable ***
${id_login}    test_it_roles
${id_name}    IT ROLE TESTING
${HOMEPAGE}    http://uat.cubesofttech.com/
${BROWSER}    chrome
${location_url}    http://uat.cubesofttech.com/check_list.action?userId=       # location when click accept

${pic_directory}    D:/CO-OP/CubeSoftTech_WorkingSpace/Code/CheckList/Picture/

${table_name}    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr      # for count
${table}    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]

@{Status_work}=        On Time    Late    Finished Work    Unfinished Work    Wait For Approve

${current_time2}=    Get Current Date    result_format=%H

${text}    22-Sep-2021 08:02\nTC-CHECK-003

*** Keywords ***
Check-in-btn
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/div[1]/div/div[2]/div/div[1]/form/div[1]/div/div[1]/div[1]
    Radio Button Should Be Set To    work_hours_type    1
Check-out-btn
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/div[1]/div/div[2]/div/div[1]/form/div[1]/div/div[1]/div[2]
    Radio Button Should Be Set To    work_hours_type    2
Click Accept
    Click Element    xpath=//*[@id="checktime"]
Click Cancel
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/div[1]/div/div[2]/div/div[1]/form/div[5]/button[2]
Click Check List
    Click Element    xpath=//*[@href="check_list?userId=${id_login}"]
    Title Should Be    check list



*** Test Case ***

# TC-CHECK-001 Login_Success
    
#     Open Browser    ${HOMEPAGE}    ${BROWSER}
#     Maximize Browser Window
#     Title Should Be    Cube SoftTech : Login
#     Wait Until Page Contains    Login to your account
#     Input Text    username    ${id_login}
#     Input Password    password    1234
#     Click button    id=submit myBtn
    
#     Title Should Be    check in
#     Wait Until Page Contains    Welcome
    
#     ${check_id}=    Get Text    xpath=/html/body/div[1]/div/div[3]/div/ul/li
#     Should Be True    '${check_id}' == '${id_login}'
#     Capture Page Screenshot    ${pic_directory}1_login.png

# Test

    # ${Mydate}    Get Current Date    result_format=%H:%M:%S
    # # Log To Console    ${Mydate}
    # ${TIME}    Subtract Time From Time    ${Mydate}    2h   verbose
    # # Log To Console    ${TIME}
    # ${Convert}    Convert Time    ${TIME}    timer    exclude_millis=yes
    # # Log To Console    ${Convert}
    # ${result} =    Split String From Right    ${Convert}    :    1
    # Log To Console    ${result}[0]

# Test
#     Connect To Database

#     @{queryResults}    Query    select * from person
#     Log To Console    @{queryResults}
#     Check if exists in database    select id from person where first_name = 'Franz Allan' and last_name = 'See'

#     Disconnect From Database

Test
    Log To Console    ${text}
    ${result} =    Split String    ${text}
    Log To Console    ${result}
    

