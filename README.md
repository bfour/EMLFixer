#EMLFixer 

EMLFixer is a tool that should fix the .eml-file timestamp change issue in Windows 10 and older by removing some metadata from the files you select (the actual files remain untouched). EMLFixer also allows you to restore your timestamps (last modification date/time) from another directory. This is thought to be helpful if you are synchronizing your files from one directory to another (eg. on a NAS). 

[![download_button](https://bfourdev.files.wordpress.com/2017/01/download_button2.png)](https://github.com/bfour/EMLFixer/raw/master/EMLFixer.zip) 

### Background

In newer versions of Windows, probably starting with Windows Vista, there is a bug/peculiar behaviour of the system that causes .eml-files (emails) and .nws-files to have their last modification timestamp changed without the user actively changing anything. This causes severe issues with synchronization tools, as they rely on these timestamps in many cases. This problem is described on [superuser.com](http://superuser.com/questions/1079988/something-in-windows-10-is-re-dating-all-of-my-archived-eml-files), as well as on [answers.microsoft.com](https://answers.microsoft.com/en-us/windows/forum/windows_7-files/why-do-eml-files-modified-date-change-on-mouseover/d6b92680-9200-4731-932f-b45c0c8187dd) and most likely many other forums. While on versions of Windows older than 10 it seems to be possible to fix this by modifying the registry with the following code, there seems to be no solution for Windows 10 so far. At least on two Windows 10 machines I tried this did not resolve the issue.

    Windows Registry Editor Version 5.00
    [-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\PropertySystem</code><code>\PropertyHandlers\.eml]
    [-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\PropertySystem\PropertyHandlers\.nws]
    [-HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\PropertySystem\PropertyHandlers\.eml]
    [-HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\PropertySystem\PropertyHandlers\.nws]

In another [post on answers.microsoft.com](https://answers.microsoft.com/en-us/windows/forum/windows_10-files/windows-10-bug-needs-fixing-now/24cc4640-4831-4bb7-b4c3-906fe87f5e23?page=2) there is a rather in-depth description of the issue in Windows 10, which points to the Zone.Identifier ADS being the root cause of the issue. Probably the Zone.Identifier is changed when the file is indexed or maybe even when explorer displays the file. Therefore, I started experimenting with removing the Zone.Identifier ADS and this finally seems to resolve the issue. This should also make any other "hotfix" unnecessary. For instance this would allow leaving property handler enabled and thus keep the indexing functions provided by windows functional. The messed up timestamps are usually the biggest problem if synchronization is involved. So a secondary issue that had to be addressed was a way to restore the timestamps. This can be done by specifying a root and sync directory. EMLFixer will automatically try to match your "local" files with the ones in the sync directory and restore the timestamps from the files in the sync directory, assuming those are the untouched/original ones.
