*** Settings ***
Library    SeleniumLibrary
Library    String
Library    DateTime
Library    BuiltIn
Library    OperatingSystem

*** Variable ***
${id_login}    test_it_roles
${id_name}    IT ROLE TESTING

${hr_login}    test_hr_role
${hr_name}    HR ROLE TESTING

${admin_login}    test_admin_role
${admin_name}    Admin Role Testing


*** Keywords ***
Click My Training
    Click Element    xpath=//*[@href="Training_list?Id=${id_login}"]
    Title Should Be    Training_list

*** Test Case ***
Set-up Directory
    Create Directory    D:/RobotFramework/Training/Picture
Finish
    Close All Browsers




    