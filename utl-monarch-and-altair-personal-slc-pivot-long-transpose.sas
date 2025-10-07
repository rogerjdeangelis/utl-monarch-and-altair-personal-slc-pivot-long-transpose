%let pgm=utl-monarch-and-altair-personal-slc-pivot-long-transpose;

%stop_submission;

Monarch and altair personal slc pivot long transpose;

github
https://github.com/rogerjdeangelis/utl-monarch-and-altair-personal-slc-pivot-long-transpose

for alternate output
https://github.com/rogerjdeangelis/utl-monarch-and-altair-personal-slc-pivot-long-transpose/blob/main/afterfix.xlsx

https://community.altair.com/discussion/20747/pivot-table-functionality?tab=all&utm_source=community-search&utm_medium=organic-search&utm_term=monarch%20excel

see my excel file in this repository

  I think there are acouple of errors in your output

   1  WRITER_2_FIRST_NAME1 should be WRITER_1_FIRST_NAME

      If you arrange the before columns in this order.
   2  You can see that there are only three groups so there can only be
      3 records per group and 9 output obsevarions not 12 that you have.

      GROUPS

       ID_FOR_                             ORIGINAL_
       IMPORT      TITLE                    TITLE_ID

      210801001    The Great Beyond          30985
      210801002    Sunshine in My Heart      30986
      210801003    Call My Name              30987


      WRITER_1_LAST_NAME
      WRITER_2_LAST_NAME
      WRITER_3_LAST_NAME

      WRITER_1_FIRST_NAME
      WRITER_2_FIRST_NAME
      WRITER_3_FIRST_NAME

      WRITER_1_SHARE
      WRITER_2_SHARE
      WRITER_3_SHARE

      WRITER_1_CODE
      WRITER_2_CODE
      WRITER_3_CODE

      LINKED_PUBLISHER_1_CODE
      LINKED_PUBLISHER_2_CODE
      LINKED_PUBLISHER_3_CODE

      PUBLISHER_1_CODE
      PUBLISHER_2_CODE
      PUBLISHER_3_CODE


      PUBLISHER_1_NAME
      PUBLISHER_2_NAME
      PUBLISHER_3_NAME

      PUBLISHER_1_SHARE
      PUBLISHER_2_SHARE
      PUBLISHER_3_SHARE

      PUBLISHER_1_Y_N
      PUBLISHER_2_Y_N
      PUBLISHER_3_Y_N

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

/*--- convert before and after to wpd tables ---*/

%utlfkil(%sysfunc(pathname(WPSWBHTM))); /*-- disable precode --*/
&_init_; /*-- enable listing output and set options          --*/

/*--- i downloader the excel file in the post renamed it and create namrdranges before and after ---*/
libname xls excel "d:/xls/monarch.xlsx";

data before;
  set xls.before(rename=(writer_2_first_name1=writer_1_first_name));
run;quit;

data after;
 set xls.after;
run;

libname xls clear;

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

%utlfkil(%sysfunc(pathname(WPSWBHTM))); /*-- disable precode --*/
&_init_; /*-- enable listing output and set options          --*/

proc contents data=before;
run;quit;

%array(ts,values=1-3);

libname xls excel "d:/xls/afterfix.xlsx";

data xls.xpo;

  set before;

  %do_over(ts,phrase=%str(
        writer_last_name      = writer_?_last_name;
        writer_first_name     = writer_?_first_name;
        writer_share          = writer_?_share;
        writer_code           = writer_?_code;
        linked_publisher_code = linked_publisher_?_code;
        publisher_code        = publisher_?_code;
        publisher_name        = publisher_?_name;
        publisher_share       = publisher_?_share;
        publisher_y_n         = publisher_?_y_n;
        output;
        ));
  keep
     id_for_import
     title
     original_title_id
     writer_last_name
     writer_first_name
     writer_share
     writer_code
     linked_publisher_code
     publisher_code
     publisher_name
     publisher_share
     publisher_y_n ;

run;quit;

proc print data=xpo;
run;quit;

libname xls clear;

                                                     WRITER_    WRITER_                        LINKED_
       ID_FOR_                           ORIGINAL_   LAST_      FIRST_    WRITER_   WRITER_   PUBLISHER_   PUBLISHER_                         PUBLISHER_   PUBLISHER_
Obs    IMPORT     TITLE                   TITLE_ID   NAME        NAME      SHARE     CODE        CODE         CODE        PUBLISHER_NAME         SHARE        Y_N

 1    210801001   The Great Beyond         30985     Lamb                   100     985645      98657        98657      Lamb Publishing           100          Y
 2    210801001   The Great Beyond         30985                 Harry        .                                                                     .
 3    210801001   The Great Beyond         30985                              .                                                                     .

 4    210801002   Sunshine in My Heart     30986     Lamb        Sam         60     985645      98657        98657      Lamb Publishing            60          Y
 5    210801002   Sunshine in My Heart     30986     Hastings    Harry       40     654236      78542        78542      Early Morning Train        40          N
 6    210801002   Sunshine in My Heart     30986                              .                                                                     .

 7    210801003   Call My Name             30987     Coltrane    Gary        50     132569      46578        46578      The Last Resort            50          Y
 8    210801003   Call My Name             30987     Lane        Terry       35     854764      98657        98657      Lamb Publishing            60          Y
 9    210801003   Call My Name             30987     Hastings    Sam         15     654236      78542        78542      Early Morning Train        15          N

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
