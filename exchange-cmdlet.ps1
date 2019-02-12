# Step 1: Open elevated command prompt. Run eseutil /mh MDB01.edb to check status of database if it was dirty shutdown.

# Step 2: Run eseutil /r to repair Exchange database. Execute the following cmdlet:
eseutil /r E02 /l “E:\EXDB12\Exchange Server\MDB01\Logs” /d “E:\EXDB12\Exchange Server\MDB01\File”

# ( where E02 is the file name of check file)
# Step 3: Now create RecoveryDB with the following command:
New-MailboxDatabase -Server mail01 -Name RecoveryDB1 -Recovery -EdbFilePath “E:\EXDB12\Exchange Server\MDB01\File\MDB01 .edb” -LogFolderPath “E:\EXDB12\Exchange Server\MDB01\Logs”

# Step 4: Once RecoveryDB is created. It’s time to mount it. Run the below command to do the same:
Mount-Database RecoveryDB01

# Step 5: Run the following command to get a list of mailboxes:
Get-MailboxStatistics -Database RecoveryDB1 | ft –auto

# Step 6: Run New-MailboxRestoreRequest to Restore mailbox to an existing user
New-MailboxRestoreRequest -SourceDatabase RecoveryDB1 -SourceStoreMailbox “Nik, Smith” -TargetMailbox newuser –AllowLegacyDNMismatch

# Note: Where “Nik, Smith” is a mailbox which need to be restored from the old database and “newuser” is a  new mailbox you just created.
# Step 7: To check the status of a restore request, execute the below command:
Get-MailboxRestoreRequest

# Step 8: Once status gets completed, remove restore request with the following cmdlet:
Get-MailboxRestoreRequest -Status Completed | Remove-MailboxRestoreRequest

# Step 9: You can convert EDB to PST PowerShell using New-MailboxExportRequest cmdlet as given below:
New-MailboxExportRequest -Mailbox niksmith -FilePath //fileshare01/PST/niksmith.pst

# Step 10: To check the status of export request, execute the below command:
Get-Mailboxexportrequest

# Step 11: Once the status of export request gets completed, remove export request with the following cmdlet:
Get-Mailboxexportrequest -status completed | Remove-Mailboxexportrequest

# Step 12: Delete data from mailbox it was imported to
Disable-Mailbox Nik.Smith@domain.com

# Step 13: Delete Recovery database with the following cmdlet:
Remove-MailboxDatabase -Identity “RecoveryDB1”

# Then manually delete the file from its location (database and log).
