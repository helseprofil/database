
# Table of Contents

1.  [Access](#org001cea0)
    1.  [Show which file](#orgdc512ae)
    2.  [Codebook](#orgac7d8ef)
2.  [Coding](#org278be9b)
    1.  [Reading rawdata](#org2b9d2c1)
        1.  [Update file](#orgdc49d76)
        2.  [Manual header or auto](#org5a758e9)
        3.  [Landbakgrunn](#org95dc1fb)
        4.  [Standard variable](#org67ccf9a)
        5.  [Year](#orgd04ea32)
        6.  [Empty correspond codes](#org213dc71)
        7.  [Cast geo codes](#orgb7772c8)
    2.  [Aggregate from database](#orga9cc38e)
        1.  [Add total](#org3abfd3d)
        2.  [Aggregating data](#orge6a6793)



<a id="org001cea0"></a>

# Access


<a id="orgdc512ae"></a>

## TODO Show which file

-   Give overview table for which FILID to which LESID in Access file


<a id="orgac7d8ef"></a>

## TODO Codebook

-   For recoding variables
-   Log showing what has been coded


<a id="org278be9b"></a>

# Coding

Either for reading rawdata or aggregate from database


<a id="org2b9d2c1"></a>

## Reading rawdata

Reading rawdata mostly in `.csv` file


<a id="orgdc49d76"></a>

### TODO Update file

-   When new rawdata being updated for a specific year that already available in
    the database how can the database be updated with the new rawdata
-   In case where rawdata are updated


<a id="org5a758e9"></a>

### TODO Manual header or auto

-   When manual header is specified for any of the standard column names, the new
    name should be referred to in the standard name specification.
-   OBS!! Need to update in the code as now the manual header is superior over
    standard name specification.


<a id="org95dc1fb"></a>

### TODO Landbakgrunn

-   Split variable \`landb\` to:
    -   `landb` with numeric
    -   `landf` recode with:
        -   0 to 1
        -   B to 2
        -   C to 3
        -   Total to 0


<a id="org67ccf9a"></a>

### TODO Standard variable

Create a list to add all the standard variables that will be used in different
analyses such as DEFAAR, AGGREGERE, manual column with $ etc.


<a id="orgd04ea32"></a>

### DONE Year

-   When not available in the rawdata, needs a column to specify year for the
    data.
-   In KHfunction such situation is handled by the arg `DEFAAR` in **ORIGINALFILER**
    table. When `AAR` in  **INNLESING** table is specified with `<$y>` then it will use `DEFAAR`


<a id="org213dc71"></a>

### DONE Empty correspond codes

-   Corresponds codes can be empty when running `norgeo::get_corrspond` coz
    nothing has happened on the selected year. Should be able to select previous
    year every time correspond codes are empty.
-   See [commit 1e0d308](https://github.com/helseprofil/database/commit/1e0d308fa9762b5d5384282ad9ce6d89c2f5e9f4) with `find_correspond()`


<a id="orgb7772c8"></a>

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


<a id="orga9cc38e"></a>

## Aggregate from database

This will produce a `.csv` file


<a id="org3abfd3d"></a>

### TODO Add total

-   Calculate total other than kjønn and alder
-   Only for:
    -   Utdanning: 0 = Total
    -   Landbakgrunn: alle = Total


<a id="orge6a6793"></a>

### TODO Aggregating data

-   Where to specify option to aggregate ie. FILGRUPPE or INNLESING level.
-   Specifying in FILGRUPPE level will be implemented in all files at once

