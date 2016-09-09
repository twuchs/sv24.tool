@echo off
echo Start + %date% @ %time:~0,8% >#xlog.log

::plenty
curl "https://www.sport-versand24.de/plenty/admin/gui_call.php?Object=mod_export@GuiDynamicFieldExportView2&Params\[gui\]=AjaxExportData&gwt_tab_id=2&presenter_id=&action=ExportDataFormat&formatDynamicUserName=mw_z_datastore_AttributeItemVariation&offset=0&rowCount=99999999999999" -H "Pragma: no-cache" -H "Accept-Encoding: gzip, deflate, sdch, br" -H "Accept-Language: de-DE,de;q=0.8" -H "Upgrade-Insecure-Requests: 1" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.89 Safari/537.36" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Referer: https://www.sport-versand24.de/plenty/admin/gui_call.php?Object=mod_export@GuiDynamicFieldExportView2&Params[gui]=&action=&no_subtitle=1&is_client=0&gwt_tab_id=2" -H "Cookie: SID_PLENTY_1742=R5LXM7U9ZP1X49H182B7GIIA070920160723; SID_PLENTY_ADMIN_1742=R5LXM7U9ZP1X49H182B7GIIA070920160723" -H "Connection: keep-alive" -H "Cache-Control: no-cache" --compressed -k -o temp_onplenty.csv
csvfix sort -sep ; -osep ; -sqf 99 -f 3:A temp_onplenty.csv >ref_nowonplenty.csv
del temp_onplenty.csv

:: adidas
curl ftp://m1058_ftp:ct003144@sport-versand24.de/Matching_Intersport_Stammdaten/out/Adidas/Adidas_Grabber_Inventory_mit_Bestand.csv -o temp_adidas.csv
csvfix order -sep ; -osep ; -sqf 99 -f 1 temp_adidas.csv | csvfix unique -sep ; -osep ; -sqf 99 >stock_adidas.csv
csvfix join -sep ; -osep ; -sqf 99 -f 1:1 -inv stock_adidas.csv ref_nowonplenty.csv >new_adidas.csv

::atixo
curl ftp://353535-artikel:Ck3Vs$9!@atixo-hosting.de/ItemAvailibility.csv -o temp_atixo.csv

::jako
curl ftp://12260:CT12260@91.103.115.171/_KUNDE/12260/katalogdaten/EAN.CSV -o temp_jako01.csv
csvfix find -sep ; -osep ; -sqf 99 -f 2 -e "Ja" temp_jako01.csv | csvfix order -sep ; -osep ; -sqf 99 -f 1 >stock_jako.csv
csvfix join -sep ; -osep ; -sqf 99 -f 1:1 -inv stock_jako.csv ref_nowonplenty.csv >new_jako.csv

::stanno
curl ftp://stanno_ean:R8GyPkPR@ftp.deventrade.com/LAGERLISTE_STANNO_REECE.csv -o temp_stanno.csv

::uhlsport
curl http://stock.uhlsportcompany.com/ATP4EDIFACT.TXT -o temp_uhl.csv

::erima
curl --user "webshare:gaiN171cliC" "http://www.erima-online.com/WebDAV/ARTICLE_ITEMS.csv" --anyauth -o temp_erima.csv

::derbystar
curl -e "XMLHttpRequest" -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:49.0) Gecko/20100101 Firefox/49.0" http://derbystar.de/files/DS_Warenbestandsliste-2.csv -o temp_derby.csv
csvfix find -sep , -osep ; -sqf 99 -f 5 -e "green" temp_derby.csv | csvfix order -sep ; -osep ; -sqf 99 -f 2 >stock_derby.csv
csvfix join -sep ; -osep ; -sqf 99 -f 1:1 -inv stock_derby.csv ref_nowonplenty.csv >new_derby.csv

