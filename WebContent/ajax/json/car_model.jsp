<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/test"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<sql:query var="model_query">
	SELECT distinct(vehicle_models.model), vehicle_models.des
	FROM vehicle_models
	JOIN vehicles ON vehicles.model = vehicle_models.model
		AND vehicles.make = vehicle_models.make
	WHERE vehicles.make = ?
	ORDER BY vehicle_models.des
	<sql:param>${param.car_make}</sql:param>
</sql:query>

<%-- JSON --%>
<json:object>
	<json:array name="car_model" var="item" items="${model_query.rows}" prettyPrint="true">
		<json:object>
			<json:property name="value" value="${item.model}"/>
			<json:property name="label" value="${item.des}"/>
		</json:object>
	</json:array>
</json:object>

<%-- JSON Result Example for car_make:MITS --%>
<%--
{"car_model": [
{
	"value": "3000GT",
	"label": "3000gt"
},
{
	"value": "380",
	"label": "380"
},
{
	"value": "ASX",
	"label": "Asx"
},
{
	"value": "CHALLEN",
	"label": "Challenger"
},
{
	"value": "COLT",
	"label": "Colt"
},
{
	"value": "CORDIA",
	"label": "Cordia"
},
{
	"value": "D50",
	"label": "D50 Express"
},
{
	"value": "DELICA",
	"label": "Delica"
},
{
	"value": "EXPRESS",
	"label": "Express"
},
{
	"value": "FTO",
	"label": "Fto"
},
{
	"value": "GALANT",
	"label": "Galant"
},
{
	"value": "GRANDIS",
	"label": "Grandis"
},
{
	"value": "GTO",
	"label": "Gto"
},
{
	"value": "I-MIEV",
	"label": "I-Miev"
},
{
	"value": "LANCER",
	"label": "Lancer"
},
{
	"value": "LEGNUM",
	"label": "Legnum"
},
{
	"value": "MAGNA",
	"label": "Magna"
},
{
	"value": "MIRAGE",
	"label": "Mirage"
},
{
	"value": "NIMBUS",
	"label": "Nimbus"
},
{
	"value": "OUTLAND",
	"label": "Outlander"
},
{
	"value": "PAJERO",
	"label": "Pajero"
},
{
	"value": "IO",
	"label": "Pajero Io"
},
{
	"value": "R-EVO",
	"label": "Ralliart Evo"
},
{
	"value": "R-MAGNA",
	"label": "Ralliart Magna"
},
{
	"value": "RVR",
	"label": "Rvr"
},
{
	"value": "SIGMA",
	"label": "Sigma"
},
{
	"value": "SCORPIO",
	"label": "Sigma Scorpion"
},
{
	"value": "STARION",
	"label": "Starion"
},
{
	"value": "STARWAG",
	"label": "Starwagon"
},
{
	"value": "TRITON",
	"label": "Triton"
},
{
	"value": "VERADA",
	"label": "Verada"
}
]}
--%>