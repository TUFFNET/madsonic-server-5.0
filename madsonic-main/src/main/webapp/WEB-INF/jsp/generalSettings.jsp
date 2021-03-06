<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%--@elvariable id="command" type="net.sourceforge.subsonic.command.GeneralSettingsCommand"--%>

<html><head>
    <%@ include file="head.jsp" %>
    <%@ include file="jquery.jsp" %>
    <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
	
	<c:if test="${customScrollbar}">
		<link href="<c:url value="/style/customScrollbar.css"/>" rel="stylesheet">
		<script type="text/javascript" src="<c:url value="/script/jquery.mousewheel.min.js"/>"></script>
		<script type="text/javascript" src="<c:url value="/script/jquery.mCustomScrollbar.js"/>"></script>
	</c:if>	
	
    <script type="text/javascript" language="javascript">
        function changePreview(theme) {
			 $('#preview1').attr('src','icons/preview/' + theme + '1.png');
			 $('#preview2').attr('src','icons/preview/' + theme + '2.png');
		}
    </script>
	
</head>
<body class="mainframe bgcolor1">
<div id="content_2" class="content_main">
<!-- CONTENT -->
 
<script type="text/javascript" src="<c:url value="/script/wz_tooltip.js"/>"></script>
<script type="text/javascript" src="<c:url value="/script/tip_balloon.js"/>"></script>

<c:import url="settingsHeader.jsp">
    <c:param name="cat" value="general"/>
    <c:param name="done" value="${command.toast}"/>
    <c:param name="warn" value="${command.statusPlayerChanged}"/>
    <c:param name="warnInfo" value="Warning <br> Videoplayer changed, check or reset your transcoding settings!"/>
</c:import>
<br>
	<div style="float:right;clear: both;position: absolute;right: 5px;top: 625px;">
		<img id="preview1" src="" alt="" >
		<img id="preview2" src="" alt="" >
	</div>

<form:form method="post" action="generalSettings.view" commandName="command">
    <table style="white-space:nowrap" class="indent">
		<tr>
            <td><fmt:message key="generalsettings.uploadfolder"/></td>
            <td>
                <form:input path="uploadFolder" size="100"/>
                <c:import url="helpToolTip.jsp"><c:param name="topic" value="uploadfolder"/></c:import>
            </td>
        </tr>
	
        <tr><td colspan="2">&nbsp;</td></tr>

		<tr>
            <td><fmt:message key="generalsettings.playlistfolder"/></td>
            <td>
                <form:input path="playlistFolder" size="100"/>
                <c:import url="helpToolTip.jsp"><c:param name="topic" value="playlistfolder"/></c:import>
            </td>
        </tr>

        <tr>
            <td><fmt:message key="generalsettings.playlistExportfolder"/></td>
            <td>
                <form:input path="playlistExportFolder" size="100"/>
                <c:import url="helpToolTip.jsp"><c:param name="topic" value="playlistExportfolder"/></c:import>
            </td>
        </tr>		
		
        <tr><td colspan="2">&nbsp;</td></tr>
		
        <tr>
            <td><fmt:message key="generalsettings.musicmask"/></td>
            <td>
                <form:input path="musicFileTypes" size="100"/>
                <c:import url="helpToolTip.jsp"><c:param name="topic" value="musicmask"/></c:import>
            </td>
        </tr>

        <tr>
            <td><fmt:message key="generalsettings.videomask"/></td>
            <td>
                <form:input path="videoFileTypes" size="100"/>
                <c:import url="helpToolTip.jsp"><c:param name="topic" value="videomask"/></c:import>
            </td>
        </tr>

        <tr>
            <td><fmt:message key="generalsettings.coverartmask"/></td>
            <td>
                <form:input path="coverArtFileTypes" size="100"/>
                <c:import url="helpToolTip.jsp"><c:param name="topic" value="coverartmask"/></c:import>
            </td>
        </tr>

        <tr><td colspan="2">&nbsp;</td></tr>

        <tr>
            <td><fmt:message key="generalsettings.index"/></td>
            <td>
                <form:input path="index" size="100"/>
                <c:import url="helpToolTip.jsp"><c:param name="topic" value="index"/></c:import>
            </td>
        </tr>

        <tr>
            <td><fmt:message key="generalsettings.index2"/></td>
            <td>
                <form:input path="index2" size="100"/>
                <c:import url="helpToolTip.jsp"><c:param name="topic" value="index"/></c:import>
            </td>
        </tr>

        <tr>
            <td><fmt:message key="generalsettings.index3"/></td>
            <td>
                <form:input path="index3" size="100"/>
                <c:import url="helpToolTip.jsp"><c:param name="topic" value="index"/></c:import>
            </td>
        </tr>		

        <tr>
            <td><fmt:message key="generalsettings.index4"/></td>
            <td>
                <form:input path="index4" size="100"/>
                <c:import url="helpToolTip.jsp"><c:param name="topic" value="index"/></c:import>
            </td>
        </tr>		

		<tr><td colspan="2">&nbsp;</td></tr>
		
        <tr>
            <td><fmt:message key="generalsettings.ignoredarticles"/></td>
            <td>
                <form:input path="ignoredArticles" size="100"/>
                <c:import url="helpToolTip.jsp"><c:param name="topic" value="ignoredarticles"/></c:import>
            </td>
        </tr>
	
		
        <tr>
            <td><fmt:message key="generalsettings.shortcuts"/></td>
            <td>
                <form:input path="shortcuts" size="100"/>
                <c:import url="helpToolTip.jsp"><c:param name="topic" value="shortcuts"/></c:import>
            </td>
        </tr>

        <tr><td colspan="2">&nbsp;</td></tr>

        <tr>
            <td><fmt:message key="generalsettings.language"/></td>
            <td>
                <form:select path="localeIndex" cssStyle="width:15em">
                    <c:forEach items="${command.locales}" var="locale" varStatus="loopStatus">
                        <form:option value="${loopStatus.count - 1}" label="${locale}"/>
                    </c:forEach>
                </form:select>
                <c:import url="helpToolTip.jsp"><c:param name="topic" value="language"/></c:import>
            </td>
        </tr>

        <tr>
            <td><fmt:message key="generalsettings.theme"/></td>
            <td>
                <form:select path="themeIndex" cssStyle="width:15em" onchange="changePreview(this.options[selectedIndex].label)">
                    <c:forEach items="${command.themes}" var="theme" varStatus="loopStatus">
                        <form:option value="${loopStatus.count - 1}" label="${theme.name}"/>
                    </c:forEach>
                </form:select>
                <c:import url="helpToolTip.jsp"><c:param name="topic" value="theme"/></c:import>
            </td>
        </tr>
 
		<tr>
			<td><fmt:message key="personalsettings.listtype"/></td>
			<td>
				<form:select path="listType">
					<c:forTokens items="hot newest highest frequent recent random top new" delims=" " var="cat" varStatus="loopStatus">
						<form:option value="${cat}"><fmt:message key="home.${cat}.title"/></form:option>
					</c:forTokens>
				</form:select>
				<c:import url="helpToolTip.jsp"><c:param name="topic" value="listtype"/></c:import>
			</td>
		</tr>

		<tr>
			<td><fmt:message key="generalsettings.newAdded"/></td>
			<td>
				<form:select path="newAdded">
					<c:forTokens items="Disabled OneHour OneDay OneWeek OneMonth TwoMonth ThreeMonth SixMonth OneYear" delims=" " var="timeSpan" varStatus="loopStatus">
						<form:option value="${timeSpan}"><fmt:message key="generalsettings.newAdded.${timeSpan}"/></form:option>
					</c:forTokens>
				</form:select>
				<c:import url="helpToolTip.jsp"><c:param name="topic" value="newAdded"/></c:import>
			</td>
		</tr>

        <tr><td colspan="2">&nbsp;</td></tr>		

        <tr>
            <td><fmt:message key="generalsettings.leftframeSize"/></td>
            <td><form:input path="leftframeSize" size="3"/> px
			<c:import url="helpToolTip.jsp"><c:param name="topic" value="leftframeSize"/></c:import></td>
        </tr>

        <tr>
            <td><fmt:message key="generalsettings.playQueueSize"/></td>
            <td><form:input path="playQueueSize" size="3"/> px 
			<c:import url="helpToolTip.jsp"><c:param name="topic" value="playQueueSize"/></c:import> </td>
	 </tr>	
	 
        <tr><td colspan="2">&nbsp;</td></tr>

        <tr>
            <td>
            </td>
            <td>
                <form:checkbox path="showAlbumsYear" id="showAlbumsYear"/>
                <label for="showAlbumsYear"><fmt:message key="generalsettings.showalbumsyear"/></label>
				<c:import url="helpToolTip.jsp"><c:param name="topic" value="showAlbumsYear"/></c:import>
            </td>
        </tr>

         <tr>
            <td>
            </td>
            <td>
                <form:checkbox path="showAlbumsYearApi" id="showAlbumsYearApi"/>
                <label for="showAlbumsYearApi"><fmt:message key="generalsettings.showalbumsyearapi"/></label>
 				<c:import url="helpToolTip.jsp"><c:param name="topic" value="showAlbumsYearApi"/></c:import>
            </td>
        </tr>
		<tr>
            <td>
            </td>
            <td>
                <form:checkbox path="showShortcuts" id="showShortcuts"/>
                <label for="showShortcuts"><fmt:message key="generalsettings.showShortcuts"/></label>
 				<c:import url="helpToolTip.jsp"><c:param name="topic" value="showShortcuts"/></c:import>
            </td>
        </tr>
		<tr>
            <td>
            </td>
            <td>
                <form:checkbox path="sortAlbumsByFolder" id="sortAlbumsByFolder"/>
                <label for="sortAlbumsByFolder"><fmt:message key="generalsettings.sortAlbumsByFolder"/></label>
 				<c:import url="helpToolTip.jsp"><c:param name="topic" value="sortAlbumsByFolder"/></c:import>
            </td>
        </tr>
		<tr>
            <td>
            </td>
            <td>
                <form:checkbox path="sortMediaFileFolder" id="sortMediaFileFolder"/>
                <label for="sortMediaFileFolder"><fmt:message key="generalsettings.sortMediaFileFolder"/></label>
 				<c:import url="helpToolTip.jsp"><c:param name="topic" value="sortMediaFileFolder"/></c:import>
            </td>
        </tr>

       <tr>
            <td>
            </td>
            <td>
                <form:checkbox path="sortFilesByFilename" id="sortFilesByFilename"/>
                <label for="sortFilesByFilename"><fmt:message key="generalsettings.sortFilesByFilename"/></label>
 				<c:import url="helpToolTip.jsp"><c:param name="topic" value="sortFilesByFilename"/></c:import>
            </td>
        </tr>
		
       <tr>
            <td>
            </td>
            <td>
                <form:checkbox path="folderParsing" id="folderParsing"/>
                <label for="folderParsing"><fmt:message key="generalsettings.folderParsing"/></label>
 				<c:import url="helpToolTip.jsp"><c:param name="topic" value="folderParsing"/></c:import>
            </td>
        </tr>

       <tr>
            <td>
            </td>
            <td>
                <form:checkbox path="albumSetParsing" id="albumSetParsing"/>
                <label for="albumSetParsing"><fmt:message key="generalsettings.albumSetParsing"/></label>
 				<c:import url="helpToolTip.jsp"><c:param name="topic" value="albumSetParsing"/></c:import>
            </td>
        </tr>
		
        <tr><td colspan="2">&nbsp;</td></tr>		

       <tr>
            <td>
            </td>
            <td>
                <form:checkbox path="ownGenreEnabled" id="ownGenreEnabled"/>
                <label for="ownGenreEnabled"><fmt:message key="generalsettings.ownGenreEnabled"/></label>
 				<c:import url="helpToolTip.jsp"><c:param name="topic" value="ownGenreEnabled"/></c:import>
            </td>
        </tr>

       <tr>
            <td>
            </td>
            <td>
                <form:checkbox path="playlistEnabled" id="playlistEnabled"/>
                <label for="playlistEnabled"><fmt:message key="generalsettings.playlistEnabled"/></label>
 				<c:import url="helpToolTip.jsp"><c:param name="topic" value="playlistEnabled"/></c:import>
            </td>
        </tr>


		
        <tr>
            <td>
            </td>
            <td>
                <form:checkbox path="showGenericArtistArt" id="showGenericArtistArt"/>
                <label for="showGenericArtistArt">Enable Default Artist Cover</label>
				<c:import url="helpToolTip.jsp"><c:param name="topic" value="showGenericArtistArt"/></c:import>
 
            </td>
        </tr>

        <tr>
            <td>
            </td>
            <td>
                <form:checkbox path="HTML5Enabled" id="HTML5Enabled"/>
                <label for="HTML5Enabled">Enable HTML5 Videoplayer instead of Adobe FLASH</label>
 
            </td>
        </tr>

        <tr>
            <td>
            </td>
            <td>
                <form:checkbox path="showQuickEdit" id="showQuickEdit"/>
                <label for="showQuickEdit">Enable Mediatype Quickedit Controls (only for Adminrole)</label>
				<c:import url="helpToolTip.jsp"><c:param name="topic" value="showQuickEdit"/></c:import>
 
            </td>
        </tr>
		
		<tr>
            <td>
            </td>
            <td>
                <form:checkbox path="usePremiumServices" id="usePremiumServices"/>
                <label for="usePremiumServices">Enable for Subsonic Premium Services (License needed) or use own Domain sharing.</label>
				<c:import url="helpToolTip.jsp"><c:param name="topic" value="usePremiumServices"/></c:import>
             </td>
        </tr>

        <tr><td colspan="2">&nbsp;</td></tr>		

		        <tr>
            <td><fmt:message key="generalsettings.logfileLevel"/></td>
            <td>
                <form:select path="logfileLevel" cssStyle="width:8em">
                        <form:option value="OFF"/>
                        <form:option value="ERROR"/>
                        <form:option value="WARN"/>
                        <form:option value="INFO"/>
                        <form:option value="DEBUG"/>
                        <form:option value="TEST"/>
                </form:select>
                <c:import url="helpToolTip.jsp"><c:param name="topic" value="logfileLevel"/></c:import>
            </td>
        </tr>
		
        <tr><td colspan="2">&nbsp;</td></tr>	
        <tr>
            <td>
            </td>
            <td>
                <form:checkbox path="logfileReverse" id="logfileReverse"/>
                <label for="logfileReverse"><fmt:message key="generalsettings.logfileReverse"/></label>
            </td>
        </tr>
	
        <tr><td colspan="2">&nbsp;</td></tr>		
        <tr>
            <td>
            </td>
            <td>
                <form:checkbox path="gettingStartedEnabled" id="gettingStartedEnabled"/>
                <label for="gettingStartedEnabled"><fmt:message key="generalsettings.showgettingstarted"/></label>
            </td>
        </tr>
		
		<tr><td colspan="2">&nbsp;</td></tr>
		
        <tr>
            <td><fmt:message key="generalsettings.welcometitle"/></td>
            <td>
                <form:input path="welcomeTitle" size="70"/>
                <c:import url="helpToolTip.jsp"><c:param name="topic" value="welcomemessage"/></c:import>
            </td>
        </tr>
        <tr>
            <td><fmt:message key="generalsettings.welcomesubtitle"/></td>
            <td>
                <form:input path="welcomeSubtitle" size="70"/>
                <c:import url="helpToolTip.jsp"><c:param name="topic" value="welcomemessage"/></c:import>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top;"><fmt:message key="generalsettings.welcomemessage"/></td>
            <td>
                <form:textarea path="welcomeMessage" rows="5" cols="70"/>
                <c:import url="helpToolTip.jsp"><c:param name="topic" value="welcomemessage"/></c:import>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top;"><fmt:message key="generalsettings.loginmessage"/></td>
            <td>
                <form:textarea path="loginMessage" rows="5" cols="70"/>
                <c:import url="helpToolTip.jsp"><c:param name="topic" value="loginmessage"/></c:import>
                <fmt:message key="main.wiki"/>
            </td>
        </tr>

        <tr>
            <td colspan="2" style="padding-top:1.5em">
                <input type="submit" value="<fmt:message key="common.save"/>" style="margin-right:0.3em">
                <input type="button" value="<fmt:message key="common.cancel"/>" onclick="location.href='nowPlaying.view'">
            </td>
        </tr>

    </table>
</form:form>

<c:if test="${command.reloadNeeded}">
    <script language="javascript" type="text/javascript">
        parent.frames.left.location.href="left.view?";
        parent.frames.playQueue.location.href="playQueue.view?";
    </script>
</c:if>

<c:if test="${command.fullReloadNeeded}">
    <script language="javascript" type="text/javascript">
        parent.location.href="index.view?";
    </script>
</c:if>


<!-- CONTENT -->
</div>

</body>

<c:if test="${customScrollbar}">
<script type="text/javascript">    

		(function($){
			$(window).load(function(){
				$("#content_2").mCustomScrollbar({
					set_width:false, /*optional element width: boolean, pixels, percentage*/
					set_height:false, /*optional element height: boolean, pixels, percentage*/
					horizontalScroll:false, /*scroll horizontally: boolean*/
					scrollInertia:850, /*scrolling inertia: integer (milliseconds)*/
					mouseWheel:true, /*mousewheel support: boolean*/
					mouseWheelPixels:"150", /*mousewheel pixels amount: integer, "auto"*/
					autoDraggerLength:true, /*auto-adjust scrollbar dragger length: boolean*/
					autoHideScrollbar:false, /*auto-hide scrollbar when idle*/
					scrollButtons:{ /*scroll buttons*/
						enable:true, /*scroll buttons support: boolean*/
						scrollType:"continuous", /*scroll buttons scrolling type: "continuous", "pixels"*/
						scrollSpeed:"auto", /*scroll buttons continuous scrolling speed: integer, "auto"*/
						scrollAmount:150 /*scroll buttons pixels scroll amount: integer (pixels)*/
					},
					advanced:{
						updateOnBrowserResize:false, /*update scrollbars on browser resize (for layouts based on percentages): boolean*/
						updateOnContentResize:false, /*auto-update scrollbars on content resize (for dynamic content): boolean*/
						autoExpandHorizontalScroll:false, /*auto-expand width for horizontal scrolling: boolean*/
						autoScrollOnFocus:false, /*auto-scroll on focused elements: boolean*/
						normalizeMouseWheelDelta:1 /*normalize mouse-wheel delta (-1/1)*/
					},
					contentTouchScroll:true, /*scrolling by touch-swipe content: boolean*/
					callbacks:{
						onScrollStart:function(){}, /*user custom callback function on scroll start event*/
						onScroll:function(){}, /*user custom callback function on scroll event*/
						onTotalScroll:function(){}, /*user custom callback function on scroll end reached event*/
						onTotalScrollBack:function(){}, /*user custom callback function on scroll begin reached event*/
						onTotalScrollOffset:0, /*scroll end reached offset: integer (pixels)*/
						onTotalScrollBackOffset:0, /*scroll begin reached offset: integer (pixels)*/
						whileScrolling:function(){} /*user custom callback function on scrolling event*/
					},
					theme:"light" /*"light", "dark", "light-2", "dark-2", "light-thick", "dark-thick", "light-thin", "dark-thin"*/
				});
			});
		})(jQuery);

$(".content_main").resize(function(e){
	$(".content_main").mCustomScrollbar("update");
});
</script>
</c:if>	

</html>
