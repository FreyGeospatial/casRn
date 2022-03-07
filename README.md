# casRn
This package automates the production of CAS-RN numbers given a series of analyte names. Currently, the package searches only the NIST online database for CAS numbers.

The search term must match the entry in the database being searched. For example,

`cas_rn(datasource = data.frame("analyte" = c("1h-cyclopropa[l]phenanthrene,1a,9b-dihydro", "lead")), analyte_column = 1, db = "NIST", chromever = "96.0.4664.45")`

will yield

```
                                     analyte    cas_rn
1 1h-cyclopropa[l]phenanthrene,1a,9b-dihydro  949-41-7
2                                       lead 7439-92-1
```

Typos or synonyms not found in the database will yield `NA` values.

This package is currently only available for Windows until I can create a Docker solution to allow for interoperability across all platforms.
