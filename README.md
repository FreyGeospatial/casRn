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

*6/22/2022 Update: No guarantees that this package is functional on any platform. Please standby until I can set aside time for bug fixes (or a complete overhaul of how this package is setup). However, I am happy to review any PRs, for those wishing to help :)
