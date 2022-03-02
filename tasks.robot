*** Settings ***
Documentation     Template robot main suite.
Library    RPA.Browser.Selenium    
Library    RPA.HTTP
Library    RPA.Tables
Library    RPA.PDF
#Library    XML
Library    RPA.FileSystem
Library    RPA.Archive
Library    RPA.Dialogs
Library    RPA.Robocloud.Secrets
*** Tasks ***
Order robots from Website
    Open Website
    # Ask CSV URL and Download
    # #Download CSV
    # ${orders}=    Read table from CSV    orders.csv    header=True


    # FOR    ${row}    IN    @{orders}
    #     Fill Form    ${row}
    # END

    # Click Popup
    # Zip Files
    # Close All Browsers
    # Log To Console    Fertig.


*** Keywords ***

Ask CSV URL and Download
    Add heading    Welche CSV soll geladen werden? https://robotsparebinindustries.com/orders.csv 
    Add text input    url    label=URL der CSV
    ${csv_url}=    Run Dialog
    Download    ${csv_url.url}    overwrite=True
Open Website
    ${secret}=    Get Secret    daten
    Open Available Browser    ${secret}[url]
    #Open Available Browser    https://robotsparebinindustries.com/#/robot-order

#Download CSV
#    Download    https://robotsparebinindustries.com/orders.csv    overwrite=True
 
Click Popup
    Click Button    xpath://*[@id="root"]/div/div[2]/div/div/div/div/div/button[1]

Fill Form
    
    [Arguments]    ${row}
    Click Popup
    Wait Until Page Contains    order
    Select From List By Index    head    ${row}[Head]
    Select Radio Button    body    id-body-${row}[Body]
    Press Keys    None    TAB
    Press Keys    None    ${row}[Legs]
    Input Text    address    ${row}[Address]
    Click Button    preview

    Wait Until Keyword Succeeds    5x    4s    Order ohne Fehler
    #Wait Until Keyword Succeeds    2x    3s    Click Button    order
    #Wait Until Element Is Visible    id:order-completion
    ${html}=    Get Element Attribute    id:receipt    outerHTML
    ${screenshot}=     Screenshot    id:robot-preview-image    ${OUTPUT_DIR}/temp/${row}[Order number].png
   
    Html To Pdf    ${html}    ${OUTPUT_DIR}/temp/${row}[Order number].pdf

    Open Pdf    ${OUTPUT_DIR}/temp/${row}[Order number].pdf
    ${files} =     Create List
     ...    ${OUTPUT_DIR}/temp/${row}[Order number].pdf
     ...    ${OUTPUT_DIR}/temp/${row}[Order number].png

    Add Files To Pdf    ${files}    ${OUTPUT_DIR}/temp/${row}[Order number].pdf
    Close PDF

    Wait Until Keyword Succeeds    3x    5s    Click Button    order-another
    

Order ohne Fehler
    Click Button    order
    Wait Until Element Is Visible    id:order-completion



Zip Files
    Log To Console    Ich zippe.
    ${zip}=    Set Variable    ${OUTPUT_DIR}/PDFs.zip
    Archive Folder With Zip
    ...    ${OUTPUT_DIR}/temp
    ...    ${zip}
    Log To Console    Fertig gezippt.