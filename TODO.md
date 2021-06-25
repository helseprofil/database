
# Table of Contents

1.  [Access](#orgce866fe)
    1.  [Show which file](#orgb5e3b40)
    2.  [Codebook](#org0414125)
2.  [Coding](#orga932ba6)
    1.  [Reading rawdata](#org5dead8d)
        1.  [Update file](#org79b6e25)
        2.  [Manual header or auto](#org9f5a881)
        3.  [Landbakgrunn](#org4e496da)
        4.  [Year](#org6f418b2)
        5.  [Empty correspond codes](#orgbb7cf36)
        6.  [Cast geo codes](#org69d9460)
    2.  [Aggregate from database](#org836a89c)
        1.  [Add total](#orgf5f7a1d)
        2.  [Aggregating data](#org07770ca)



<a id="orgce866fe"></a>

# Access


<a id="orgb5e3b40"></a>

## TODO Show which file

-   Give overview table for which FILID to which LESID in Access file


<a id="org0414125"></a>

## TODO Codebook

-   For recoding variables
-   Log showing what has been coded


<a id="orga932ba6"></a>

# Coding

Either for reading rawdata or aggregate from database


<a id="org5dead8d"></a>

## Reading rawdata

Reading rawdata mostly in `.csv` file


<a id="org79b6e25"></a>

### TODO Update file

-   When new rawdata being updated for a specific year that already available in
    the database how can the database be updated with the new rawdata
-   In case where rawdata are updated


<a id="org9f5a881"></a>

### TODO Manual header or auto

-   When manual header is specified for any of the standard column names, the new
    name should be refered to in the standard name specification.
-   OBS!! Need to update in the code as now the manual header is superior over
    standard name specification.


<a id="org4e496da"></a>

### TODO Landbakgrunn

-   Split variable \`landb\` to:
    -   `landb` with numeric
    -   `landf` recode with:
        -   0 to 1
        -   B to 2
        -   C to 3
        -   Total to 0


<a id="org6f418b2"></a>

### TODO Year

-   When not available in the rawdata, needs a column to specify year for the
    data.
-   In KHfunction such situation is handled by the arg in DEFAAR when AAR
    is specified with <$y>


<a id="orgbb7cf36"></a>

### DONE Empty correspond codes

-   Corresponds codes can be empty when running `norgeo::get_corrspond` coz
    nothing has happened on the selected year. Should be able to select previous
    year every time correspond codes are empty.
-   See [commit 1e0d308](https://github.com/helseprofil/database/commit/1e0d308fa9762b5d5384282ad9ce6d89c2f5e9f4) with `find_correspond()`


<a id="org69d9460"></a>

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


<a id="org836a89c"></a>

## Aggregate from database

This will produce a `.csv` file


<a id="orgf5f7a1d"></a>

### TODO Add total

-   Calculate total other than kjønn and alder
-   Only for:
    -   Utdanning: 0 = Total
    -   Landbakgrunn: alle = Total


<a id="org07770ca"></a>

### TODO Aggregating data

-   Where to specify option to aggregate ie. FILGRUPPE or INNLESING level.
-   Specifying in FILGRUPPE level will be implemented in all files at once

