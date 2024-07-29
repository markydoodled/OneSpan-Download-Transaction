Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to fetch available transactions (packages) using OneSpan API
function FetchTransactions {
    # Define the OneSpan API endpoint and the API key (replace with your actual API key)
    $apiUrl = "https://api.onespan.com/api/packages"
    $apiKey = "YOUR_API_KEY"

    # Make the API call to fetch the transactions
    try {
        $response = Invoke-RestMethod -Uri $apiUrl -Method Get -Headers @{ "Authorisation" = "Bearer $apiKey" }

        # Display the transactions in the list box
        $transactionList.Items.Clear()
        foreach ($transaction in $response) {
            $transactionList.Items.Add("ID: $($transaction.id), Name: $($transaction.name)")
        }

        if ($transactionList.Items.Count -eq 0) {
            $transactionList.Items.Add("No Transactions Found.")
        }
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error: $_")
    }
}

# Function to download the document zip of a selected transaction using OneSpan API
function DownloadDocumentZip {
    param (
        [string]$packageID
    )

    # Define the OneSpan API endpoint and the API key (replace with your actual API key)
    $apiUrl = "https://api.onespan.com/api/packages/$packageID/documents/zip"
    $apiKey = "YOUR_API_KEY"

    # Specify the output file path for the downloaded zip
    $outputFilePath = "$([System.IO.Path]::GetTempPath())$packageID.zip"

    # Make the API call to download the document zip
    try {
        Invoke-RestMethod -Uri $apiUrl -Method Get -Headers @{ "Authorisation" = "Bearer $apiKey" } -OutFile $outputFilePath

        [System.Windows.Forms.MessageBox]::Show("Document Zip Downloaded Successfully To $outputFilePath")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error: $_")
    }
}

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "OneSpan Transactions"
$form.Size = New-Object System.Drawing.Size(500, 400)

# Create the fetch transactions button
$fetchButton = New-Object System.Windows.Forms.Button
$fetchButton.Text = "Fetch Transactions"
$fetchButton.Location = New-Object System.Drawing.Point(10, 20)
$fetchButton.Size = New-Object System.Drawing.Size(150, 30)
$fetchButton.Add_Click({
    FetchTransactions
})
$form.Controls.Add($fetchButton)

# Create the list box to display transactions
$transactionList = New-Object System.Windows.Forms.ListBox
$transactionList.Location = New-Object System.Drawing.Point(10, 60)
$transactionList.Size = New-Object System.Drawing.Size(460, 250)
$form.Controls.Add($transactionList)

# Create the download button
$downloadButton = New-Object System.Windows.Forms.Button
$downloadButton.Text = "Download Document Zip"
$downloadButton.Location = New-Object System.Drawing.Point(10, 320)
$downloadButton.Size = New-Object System.Drawing.Size(150, 30)
$downloadButton.Add_Click({
    if ($transactionList.SelectedItem) {
        $selectedTransaction = $transactionList.SelectedItem.ToString()
        $packageID = ($selectedTransaction -split "ID: ")[1] -split ", Name: ")[0]
        DownloadDocumentZip -packageID $packageID
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please Select A Transaction.")
    }
})
$form.Controls.Add($downloadButton)

# Show the form
[void]$form.ShowDialog()
