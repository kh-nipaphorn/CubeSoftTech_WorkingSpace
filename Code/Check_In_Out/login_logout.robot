*** Settings ***
Library    SeleniumLibrary
Library    String
Library    DateTime

*** Variable ***
${HOMEPAGE}    http://uat.cubesofttech.com/
${BROWSER}    chrome

*** Test Case ***
Login
    Open Browser    ${HOMEPAGE}    ${BROWSER}
    Maximize Browser Window
    Title Should Be    Cube SoftTech : Login
    Wait Until Page Contains    Login to your account
    Input Text    username    test_it_role
    Input Password    password    1234
    Click button    submit myBtn

    # Title Should Be    check in
    # Wait Until Page Contains    Welcome
    # Page Should Contain    test_it_role
    # Capture Page Screenshot    1_login.png

Check in (Something)
    #selecting check in/out radio button
    # Select Radio Button    id:checkbox1_1
    # Click Element    id:checkbox1_1
    # Click Element    id:checkbox1_2
    # Click Element    xpath://*[@id="checkbox1_1"]
    # Click Element    xpath://*[@id="checkbox1_2"]
    # Click Element    xpath://*[/html/body/div[3]/div[2]/div/div[2]/div[2]/div[1]/div/div[2]/div/div[1]/form/div[1]/div/div[1]/div[1]]    #check-in
    # Click Element    xpath://*[/html/body/div[3]/div[2]/div/div[2]/div[2]/div[1]/div/div[2]/div/div[1]/form/div[1]/div/div[1]/div[2]]    #check-out
    # Select Radio Button    work_hours_type    1
    # Select Radio Button    work_hours_type    2
    # Select Radio Button    work_hours_type    checkbox1_1
    # Select Radio Button    work_hours_type    checkbox1_2
    # Radio Button Should Be Set To    work_hours_type    1
    # Radio Button Should Be Set To    work_hours_type    2
    
    #Check Date
    # ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    # Wait Until Page Contains    ${currentDate}

    #Check Time
    # ${currentTime}    Get Current Date    result_format=%H:%M
    # Wait Until Page Contains    ${currentTime}

    #Click Accept Button to Check in
    # Click Button    checktime

    #                                 Try to Handle Table
    Click Element    xpath://a[@href="check_list?userId=test_it_role"]


    #Check Data
    Wait Until Page Contains    Check List
    
    ${rows}=    Get Element Count    xpath://table[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr
    ${cols}=    Get Element Count    xpath://table[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[1]/td

    Log To Console    ${rows}
    Log To Console    ${cols}

    # Close Browser

    # I will Back Soon
    # I will Back Soon
    # I will Back Soon
    # I will Back Soon
    # I will Back Soon
    # I will Back Soon
    # I will Back Soon