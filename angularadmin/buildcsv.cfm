<cfcontent type="text/csv">
<cfheader name="Content-disposition" value="attachment;filename=export.csv">
<cfoutput>#form.csvdata#</cfoutput>