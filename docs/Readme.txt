FOR LAZARUS

Just Register lazregisterextcomp package.
Register your ibx, zeos, dbnet data connexion pakage.

Need to compile lazextcore or typhonextcore one time before linking lazarus.

Versioning is in each unit and global versioning is un lazextcomponents.lpk

Now Extended uses rx and other lazarus components from lazarus-ccr SVN repositories.

You need te find each version compiling looking at each component log.

For Extended extensions : 

extends.inc and dlcompilers.inc must be copied to inherited packages with root extendsinc.sh or extendsinc.bat. Verify directories in these files.

ExtCopy may use imagemagick and magickwand development libraries.

Use Fortes Report version 3.24 from official web site

FOR DELPHI

Just register ExtComponents package with no register, no docs and no demos directories.
