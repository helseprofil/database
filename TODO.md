
# Table of Contents

1.  [Access](#org4e94f6d)
    1.  [Show which file](#org2dceef9)
2.  [Coding](#org12d7ded)
    1.  [Add total](#orgb3ef10c)
    2.  [Aggregating data](#org8adfd19)
    3.  [Update file](#org3c77a37)
    4.  [Manual header or auto](#org5b98aee)
    5.  [Landbakgrunn](#orgabc5892)
    6.  [Empty correspond codes](#org95a8aca)
    7.  [Cast geo codes](#orgb90a01a)



<a id="org4e94f6d"></a>

# Access


<a id="org2dceef9"></a>

## TODO Show which file

-   Give overview table for which FILID to which LESID in Access file


<a id="org12d7ded"></a>

# Coding


<a id="orgb3ef10c"></a>

## TODO Add total

-   Calculate total other than kjønn and alder
-   Only for:
    -   Utdanning: 0 = Total
    -   Landbakgrunn: alle = Total


<a id="org8adfd19"></a>

## TODO Aggregating data

-   Where to specify option to aggregate ie. FILGRUPPE or INNLESING level.
-   Specifying in FILGRUPPE level will be implemented in all files at once


<a id="org3c77a37"></a>

## TODO Update file

-   Able to update file for a specific year
-   In case where rawdata are updated


<a id="org5b98aee"></a>

## TODO Manual header or auto

-   When manual header is specified for any of the standard column names, the new
    name should be refered to in the standard name specification.
-   OBS!! Need to update in the code as now the manual header is superior over
    standard name specification.


<a id="orgabc5892"></a>

## TODO Landbakgrunn

-   Split variable \`landb\` to:
    -   `landb` with numeric
    -   `landf` recode with:
        -   0 to 1
        -   B to 2
        -   C to 3
        -   Total to 0


<a id="org95a8aca"></a>

## DONE Empty correspond codes

-   Corresponds codes can be empty when running `norgeo::get_corrspond` coz
    nothing has happened on the selected year. Should be able to select previous
    year every time correspond codes are empty.
-   See [commit 1e0d308](https://github.com/helseprofil/database/commit/1e0d308fa9762b5d5384282ad9ce6d89c2f5e9f4) with `find_correspond()`


<a id="orgb90a01a"></a>

## DONE Cast geo codes

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

