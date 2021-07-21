
# Table of Contents

1.  [Access](#orgb934ddd)
    1.  [Show which file](#orgf4032e9)
    2.  [Codebook](#org644d347)
2.  [Coding](#org2f41509)
    1.  [Reading rawdata](#org77160d8)
        1.  [Update file](#org4cb84ea)
        2.  [Manual header or auto](#org00f651e)
        3.  [Landbakgrunn](#orgec19373)
        4.  [Year](#org8a10a0a)
        5.  [Empty correspond codes](#org7605edf)
        6.  [Cast geo codes](#org75fa90c)
    2.  [Aggregate from database](#org7f03d2a)
        1.  [Add total](#org6edcb10)
        2.  [Aggregating data](#org2b96c11)



<a id="orgb934ddd"></a>

# Access


<a id="orgf4032e9"></a>

## TODO Show which file

-   Give overview table for which FILID to which LESID in Access file


<a id="org644d347"></a>

## TODO Codebook

-   For recoding variables
-   Log showing what has been coded


<a id="org2f41509"></a>

# Coding

Either for reading rawdata or aggregate from database


<a id="org77160d8"></a>

## Reading rawdata

Reading rawdata mostly in `.csv` file


<a id="org4cb84ea"></a>

### TODO Update file

-   When new rawdata being updated for a specific year that already available in
    the database how can the database be updated with the new rawdata
-   In case where rawdata are updated


<a id="org00f651e"></a>

### TODO Manual header or auto

-   When manual header is specified for any of the standard column names, the new
    name should be referred to in the standard name specification.
-   OBS!! Need to update in the code as now the manual header is superior over
    standard name specification.


<a id="orgec19373"></a>

### TODO Landbakgrunn

-   Split variable \`landb\` to:
    -   `landb` with numeric
    -   `landf` recode with:
        -   0 to 1
        -   B to 2
        -   C to 3
        -   Total to 0


<a id="org8a10a0a"></a>

### TODO Year

-   When not available in the rawdata, needs a column to specify year for the
    data.
-   In KHfunction such situation is handled by the arg `DEFAAR` in **ORIGINALFILER**
    table. When `AAR` in  **INNLESING** table is specified with `<$y>` then it will use `DEFAAR`


<a id="org7605edf"></a>

### DONE Empty correspond codes

-   Corresponds codes can be empty when running `norgeo::get_corrspond` coz
    nothing has happened on the selected year. Should be able to select previous
    year every time correspond codes are empty.
-   See [commit 1e0d308](https://github.com/helseprofil/database/commit/1e0d308fa9762b5d5384282ad9ce6d89c2f5e9f4) with `find_correspond()`


<a id="org75fa90c"></a>

### DONE Cast geo codes

-   Create function to cast all the granularity levels eg.
    
    <table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">
    
    
    <colgroup>
    <col  class="org-right" />
    
    <col  class="org-right" />
    
    <col  class="org-left" />
    
    <col  class="org-left" />
    
    <col  class="org-right" />
    
    <col  class="org-right" />
    
    <col  class="org-left" />
    
    <col  class="org-left" />
    </colgroup>
    <thead>
    <tr>
    <th scope="col" class="org-right">codes</th>
    <th scope="col" class="org-right">year</th>
    <th scope="col" class="org-left">level</th>
    <th scope="col" class="org-left">grks</th>
    <th scope="col" class="org-right">fylke</th>
    <th scope="col" class="org-right">kommune</th>
    <th scope="col" class="org-left">bydel</th>
    <th scope="col" class="org-left">etc</th>
    </tr>
    </thead>
    
    <tbody>
    <tr>
    <td class="org-right">0320333</td>
    <td class="org-right">2021</td>
    <td class="org-left">grks</td>
    <td class="org-left">0333333</td>
    <td class="org-right">03</td>
    <td class="org-right">0320</td>
    <td class="org-left">032141</td>
    <td class="org-left">xx</td>
    </tr>
    
    
    <tr>
    <td class="org-right">0322</td>
    <td class="org-right">2021</td>
    <td class="org-left">kommune</td>
    <td class="org-left">NA</td>
    <td class="org-right">03</td>
    <td class="org-right">0322</td>
    <td class="org-left">NA</td>
    <td class="org-left">xx</td>
    </tr>
    </tbody>
    </table>
-   See function `cast_geo()`


<a id="org7f03d2a"></a>

## Aggregate from database

This will produce a `.csv` file


<a id="org6edcb10"></a>

### TODO Add total

-   Calculate total other than kjønn and alder
-   Only for:
    -   Utdanning: 0 = Total
    -   Landbakgrunn: alle = Total


<a id="org2b96c11"></a>

### TODO Aggregating data

-   Where to specify option to aggregate ie. FILGRUPPE or INNLESING level.
-   Specifying in FILGRUPPE level will be implemented in all files at once

