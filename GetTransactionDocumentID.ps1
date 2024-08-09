# Set the API key and base URL
$apiKey = "your_api_key"
$apiUrl = "https://apps.esignlive.eu/api/packages"

# Create headers for authentication
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Basic $apiKey")

# Function to download a transaction
function Download-Transaction {
    param (
        [string]$transactionId
    )
    
    $transactionUrl = "$apiUrl/$transactionId"
    
    try {
        $response = Invoke-RestMethod -Uri $transactionUrl -Headers $headers -Method Get
        Write-Output "Transaction Downloaded Successfully. Response: $response"
        # Save response to a file (optional)
        $response | Out-File "transaction_$transactionId.json"
    } catch {
        Write-Output "Transaction Download Failed. Error: $_"
    }
}

# Example usage: Replace 'your-transaction-id' with the actual transaction ID you want to download
$transactionId = Read-Host -Prompt "Enter the transaction ID"
Download-Transaction -transactionId $transactionId

Read-Host -Prompt "Press any key to close the window..."
