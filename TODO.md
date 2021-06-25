
# Table of Contents

1.  [Access](#org82ada2a)
    1.  [Show which file](#org2e0dd0d)
    2.  [Codebook](#org099db7f)
2.  [Coding](#orgcf7826a)
    1.  [Add total](#orge09bb48)
    2.  [Aggregating data](#orgc9b3954)
    3.  [Update file](#org7109bac)
    4.  [Manual header or auto](#org06d5bad)
    5.  [Landbakgrunn](#orgb3e3760)
    6.  [Year](#org6914c98)
    7.  [Empty correspond codes](#orgeb73910)
    8.  [Cast geo codes](#orgc4031db)



<a id="org82ada2a"></a>

# Access


<a id="org2e0dd0d"></a>

## TODO Show which file

-   Give overview table for which FILID to which LESID in Access file


<a id="org099db7f"></a>

## TODO Codebook

-   For recoding variables
-   Log showing what has been coded


<a id="orgcf7826a"></a>

# Coding


<a id="orge09bb48"></a>

## TODO Add total

-   Calculate total other than kjønn and alder
-   Only for:
    -   Utdanning: 0 = Total
    -   Landbakgrunn: alle = Total


<a id="orgc9b3954"></a>

## TODO Aggregating data

-   Where to specify option to aggregate ie. FILGRUPPE or INNLESING level.
-   Specifying in FILGRUPPE level will be implemented in all files at once


<a id="org7109bac"></a>

## TODO Update file

-   Able to update file for a specific year
-   In case where rawdata are updated


<a id="org06d5bad"></a>

## TODO Manual header or auto

-   When manual header is specified for any of the standard column names, the new
    name should be refered to in the standard name specification.
-   OBS!! Need to update in the code as now the manual header is superior over
    standard name specification.


<a id="orgb3e3760"></a>

## TODO Landbakgrunn

-   Split variable \`landb\` to:
    -   `landb` with numeric
    -   `landf` recode with:
        -   0 to 1
        -   B to 2
        -   C to 3
        -   Total to 0


<a id="org6914c98"></a>

## TODO Year

-   When not available in the rawdata, needs a column to specify year for the
    data.
-   Arg in DEFAAR in KHfunction is used when AAR is specified with <$y>


<a id="orgeb73910"></a>

## DONE Empty correspond codes

-   Corresponds codes can be empty when running `norgeo::get_corrspond` coz
    nothing has happened on the selected year. Should be able to select previous
    year every time correspond codes are empty.
-   See [commit 1e0d308](https://github.com/helseprofil/database/commit/1e0d308fa9762b5d5384282ad9ce6d89c2f5e9f4) with `find_correspond()`


<a id="orgc4031db"></a>

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

