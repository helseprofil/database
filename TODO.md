
# Table of Contents

1.  [Access](#orgfa227cb)
    1.  [Show which file](#org7fff4f5)
    2.  [Codebook](#org12eeb45)
2.  [Coding](#orgf5781d7)
    1.  [Reading rawdata](#org0814ca0)
        1.  [Update file](#org984bc1c)
        2.  [Manual header or auto](#org6b382d0)
        3.  [Landbakgrunn](#orgce8befa)
        4.  [Standard variable](#org0575b06)
        5.  [Year](#org3b77e13)
        6.  [Empty correspond codes](#org94907dc)
        7.  [Cast geo codes](#orgf8a5ed5)
    2.  [Aggregate from database](#org9c26bfc)
        1.  [Add total](#org410b3e5)
        2.  [Aggregating data](#org8ce5944)



<a id="orgfa227cb"></a>

# Access


<a id="org7fff4f5"></a>

## TODO Show which file

-   Give overview table for which FILID to which LESID in Access file


<a id="org12eeb45"></a>

## TODO Codebook

-   For recoding variables
-   Log showing what has been coded


<a id="orgf5781d7"></a>

# Coding

Either for reading rawdata or aggregate from database


<a id="org0814ca0"></a>

## Reading rawdata

Reading rawdata mostly in `.csv` file


<a id="org984bc1c"></a>

### TODO Update file

-   When new rawdata being updated for a specific year that already available in
    the database how can the database be updated with the new rawdata
-   In case where rawdata are updated


<a id="org6b382d0"></a>

### TODO Manual header or auto

-   When manual header is specified for any of the standard column names, the new
    name should be referred to in the standard name specification.
-   OBS!! Need to update in the code as now the manual header is superior over
    standard name specification.


<a id="orgce8befa"></a>

### TODO Landbakgrunn

-   Split variable \`landb\` to:
    -   `landb` with numeric
    -   `landf` recode with:
        -   0 to 1
        -   B to 2
        -   C to 3
        -   Total to 0


<a id="org0575b06"></a>

### TODO Standard variable

Create a list to add all the standard variables that will be used in different
analyses such as DEFAAR, AGGREGERE, manual column with $ etc.


<a id="org3b77e13"></a>

### DONE Year

-   When not available in the rawdata, needs a column to specify year for the
    data.
-   In KHfunction such situation is handled by the arg `DEFAAR` in **ORIGINALFILER**
    table. When `AAR` in  **INNLESING** table is specified with `<$y>` then it will use `DEFAAR`
-   See commit [01b7a7](https://github.com/helseprofil/database/commit/01b7a7aed2cf84690f17e76a12b9678e632a066d)


<a id="org94907dc"></a>

### DONE Empty correspond codes

-   Corresponds codes can be empty when running `norgeo::get_corrspond` coz
    nothing has happened on the selected year. Should be able to select previous
    year every time correspond codes are empty.
-   See [commit 1e0d308](https://github.com/helseprofil/database/commit/1e0d308fa9762b5d5384282ad9ce6d89c2f5e9f4) with `find_correspond()`


<a id="orgf8a5ed5"></a>

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


<a id="org9c26bfc"></a>

## Aggregate from database

This will produce a `.csv` file


<a id="org410b3e5"></a>

### TODO Add total

-   Calculate total other than kjønn and alder
-   Only for:
    -   Utdanning: 0 = Total
    -   Landbakgrunn: alle = Total


<a id="org8ce5944"></a>

### TODO Aggregating data

-   Where to specify option to aggregate ie. FILGRUPPE or INNLESING level.
-   Specifying in FILGRUPPE level will be implemented in all files at once

