<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
    <%@ include file="head.jsp" %>
    
    <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/swfobject.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/webfx/range.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/webfx/timer.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/webfx/slider.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/util.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/interface/nowPlayingService.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/interface/playQueueService.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/interface/playlistService.js"/>"></script>

    <link type="text/css" rel="stylesheet" href="<c:url value="/script/webfx/luna.css"/>">
	
    <%@ include file="jquery.jsp" %>
    
    <c:if test="${model.customScrollbar}">
    <link href="<c:url value="/style/customScrollbar.css"/>" rel="stylesheet">
    <script type="text/javascript" src="<c:url value="/script/jquery.mousewheel.min.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/jquery.mCustomScrollbar.js"/>"></script>
    </c:if>

	<c:if test="${not model.customScrollbar}">
	<style type="text/css">
		.content_playqueue{position:absolute; left:0px; top:0px; margin-left:10px; padding:0 0;}
	</style>
	<script type="text/javascript" src="<c:url value="/script/smooth-scroll.js"/>"></script>
	</c:if>	

<style type="text/css">
		tr {
		margin: 0 0 1em 0;
		padding: 0;
		}

		td {
		margin: 0 0 1em 0;
		padding: 0;
		} 

		/*Style sheet used for demo. Remove if desired*/
		.handcursor{
		cursor:hand;
		cursor:pointer;
}
 </style>
</head>

<body class="bgcolor2 playlistframe" onload="init()">

<script type="text/javascript" language="javascript">
    var player = null;
    var songs = null;
    var currentAlbumUrl = null;
    var currentStreamUrl = null;
    var currentStreamIndex = null;
    var startPlayer = false;
    var PlayLast = false;
    var repeatEnabled = false;
    var pandoraEnabled = false;
    var slider = null;

    function init() {
        dwr.engine.setErrorHandler(null);
        startTimer();

        $("#dialog-select-playlist").dialog({resizable: true, height: 180, position: 'top', modal: true, autoOpen: false,
            buttons: {
                "<fmt:message key="common.cancel"/>": function() {
                    $(this).dialog("close");
                }
            }});

    <c:choose>
    <c:when test="${model.player.web}">
        createPlayer();
    </c:when>
    <c:otherwise>
        getPlayQueue();
    </c:otherwise>
    </c:choose>
    }

    function startTimer() {
        <!-- Periodically check if the current song has changed. -->
        nowPlayingService.getNowPlayingForCurrentPlayer(nowPlayingCallback);
        setTimeout("startTimer()", 10000);
    }

    function nowPlayingCallback(nowPlayingInfo) {
        if (nowPlayingInfo != null && nowPlayingInfo.streamUrl != currentStreamUrl) {
            getPlayQueue();
            if (currentAlbumUrl != nowPlayingInfo.albumUrl && parent.main.updateNowPlaying) {
                parent.main.location.replace("nowPlaying.view?");
                currentAlbumUrl = nowPlayingInfo.albumUrl;
            }
        <c:if test="${not model.player.web}">
            currentStreamUrl = nowPlayingInfo.streamUrl;
            updateCurrentImage();
        </c:if>
        }
    }

    function createPlayer() {
        var flashvars = {
            backcolor:"<spring:theme code="backgroundColor"/>",
            frontcolor:"<spring:theme code="textColor"/>",
            id:"player1",
            "viral.allowmenu": "false",
            "viral.oncomplete": "false",
            "viral.onpause": "false"
        };
        var params = {
            allowfullscreen:"true",
            allowscriptaccess:"always"
        };
        var attributes = {
            id:"player1",
            name:"player1"
        };
        swfobject.embedSWF("<c:url value="/flash/jw-player-5.10.swf"/>", "placeholder", "340", "24", "9.0.0", false, flashvars, params, attributes);
    }

    function playerReady(thePlayer) {
        player = document.getElementById("player1");
        player.addModelListener("STATE", "stateListener");
        getPlayQueue();
    }

    function stateListener(obj) { // IDLE, BUFFERING, PLAYING, PAUSED, COMPLETED
	
        if (obj.newstate == "COMPLETED") {
			if (getCurrentSongIndex() == songs.length - 1) {
			
				if (pandoraEnabled) {
					var artists = [];
					var albums = [];
					var genres = [];
					var moods = [];

					for ( var m = 0; m < songs.length; m++) {
						if (moods.indexOf(songs[m].mood) > -1) {
						} else {
							moods.push(songs[m].mood);
						}
					}
					
					for ( var g = 0; g < songs.length; g++) {
						if (genres.indexOf(songs[g].genre) > -1) {
						} else {
							genres.push(songs[g].genre);
						}
					}
					for ( var a = 0; a < songs.length; a++) {
						if (artists.indexOf(songs[a].artist) > -1) {
						} else {
							artists.push(songs[a].artist);
						}
					}
					for ( var c = 0; c < songs.length; c++) {
						if (albums.indexOf(songs[c].album) > -1) {
						} else {
							albums.push(songs[c].album);
						}
					}
					onPlayPandoraRadio(artists, albums, genres, moods);
					} 
				} 
				onNext(repeatEnabled);
        }
    }

    function getPlayQueue() {
        playQueueService.getPlayQueue(playQueueCallback);
    }

    function onClear() {
        var ok = true;
    <c:if test="${model.partyMode}">
        ok = confirm("<fmt:message key="playlist.confirmclear"/>");
    </c:if>
        if (ok) {
            playQueueService.clear(playQueueCallback);
        }
    }
	
    function onStart() {
        playQueueService.start(playQueueCallback);
    }
    function onStop() {
        playQueueService.stop(playQueueCallback);
    }
    function onGain(gain) {
        playQueueService.setGain(gain);
    }
    function onSkip(index) {
    <c:choose>
    <c:when test="${model.player.web}">
		currentStreamIndex = index;
        skip(index);
    </c:when>
    <c:otherwise>
		currentStreamIndex = index;
        currentStreamUrl = songs[index].streamUrl;
        playQueueService.skip(index, playQueueCallback);
    </c:otherwise>
    </c:choose>
    }

	function setNotification(song)
   {
      var n;

      //webkitNotifications
      if (window.webkitNotifications.checkPermission() != 0)
      {
         setAllowNotification();
         return 0;
      }

      n = window.webkitNotifications.createNotification('/coverArt.view?id=' + song.id + '&size=48', song.title, song.artist + ' - ' + song.album); 
	  
      n.ondisplay = function() {
               setTimeout(function(){
                  n.cancel();
               },5000); };
      n.show();
   }
   
   function setAllowNotification()
   {
      window.webkitNotifications.requestPermission(permissionGranted);
   }

   function permissionGranted()
   {
      if (window.webkitNotifications.checkPermission() == 0)
         setNotification();
   }

    function onNext(wrap) {
        var index = parseInt(getCurrentSongIndex()) + 1;

        if (wrap) {
		index = index % songs.length;
        }
	skip(index);
    }
	
    function onPrevious() {
        skip(parseInt(getCurrentSongIndex()) - 1);
    }
    function onPlay(id) {
        startPlayer = true;
        PlayLast = false;
        playQueueService.play(id, playQueueCallback);
    }

    function onPlayAdd(id) {
        startPlayer = true;
        PlayLast = true;
        playQueueService.add(id, playQueueCallback);
    }

    function onAddPlaylist(id) {
        startPlayer = false;
        PlayLast = false;
        playQueueService.AddPlaylist(id, playQueueCallback);
    }
	
    function onPlayPlaylist(id) {
        startPlayer = true;
        playQueueService.playPlaylist(id, playQueueCallback);
    }

    function onPlayRandom(id, count) {
        startPlayer = true;
        PlayLast = false;
        playQueueService.playRandom(id, count, playQueueCallback);
    }

    function onPlayPandoraRadio(artist, album, genres, tags) {
        startPlayer = true;
        PlayLast = false;
		playQueueService.playPandoraRadio(artist, album, genres, tags, playQueueCallback);
    }
	
    function onAdd(id) {
        startPlayer = false;
        PlayLast = false;
        playQueueService.add(id, playQueueCallback);
    }

    function onAddNext(id) {
        startPlayer = false;
        playQueueService.addAt(id, getCurrentSongIndex() + 1, playQueueCallback);
    }


    function onPlayGenreRadio(genres, count) {
		startPlayer = true;
		playQueueService.playGenreRadio(genres, count, playQueueCallback);
    }	
	
	function onPlayMoodRadio(moods, count) {
		startPlayer = true;
		playQueueService.playMoodRadio(moods, count, playQueueCallback);
    }	
	
    function onShuffle() {
        playQueueService.shuffle(playQueueCallback);
    }
    function onStar(index) {
        playQueueService.toggleStar(index, playQueueCallback);
    }
    function onRemove(index) {
        playQueueService.remove(index, playQueueCallback);
    }
    function onRemoveSelected() {
        var indexes = new Array();
        var counter = 0;
        for (var i = 0; i < songs.length; i++) {
            var index = i + 1;
            if ($("#songIndex" + index).is(":checked")) {
                indexes[counter++] = i;
            }
        }
        playQueueService.removeMany(indexes, playQueueCallback);
    }

    function onUp(index) {
        playQueueService.up(index, playQueueCallback);
    }
    function onDown(index) {
        playQueueService.down(index, playQueueCallback);
    }
    function onToggleRepeat() {
        playQueueService.toggleRepeat(playQueueCallback);
	}
	function onTogglePandora() {
        playQueueService.togglePandora(playQueueCallback);
	}
    function onUndo() {
        playQueueService.undo(playQueueCallback);
    }
    function onSortByTrack() {
        playQueueService.sortByTrack(playQueueCallback);
    }
    function onSortByArtist() {
        playQueueService.sortByArtist(playQueueCallback);
    }
    function onSortByAlbum() {
        playQueueService.sortByAlbum(playQueueCallback);
    }
    function onSavePlaylist() {
        playQueueService.savePlaylist(function () {
            parent.left.updatePlaylists();
            $().toastmessage("showSuccessToast", "<fmt:message key="playlist.toast.saveasplaylist"/>");
        });
    }
    function onAppendPlaylist() {
        playlistService.getWritablePlaylists(playlistCallback);
    }
    function playlistCallback(playlists) {
        $("#dialog-select-playlist-list").empty();
        for (var i = 0; i < playlists.length; i++) {
            var playlist = playlists[i];
            $("<p class='dense'><b><a href='#' onclick='appendPlaylist(" + playlist.id + ")'>" + playlist.name + "</a></b></p>").appendTo("#dialog-select-playlist-list");
        }
        $("#dialog-select-playlist").dialog("open");
    }
    function appendPlaylist(playlistId) {
        $("#dialog-select-playlist").dialog("close");

        var mediaFileIds = new Array();
        for (var i = 0; i < songs.length; i++) {
            if ($("#songIndex" + (i + 1)).is(":checked")) {
                mediaFileIds.push(songs[i].id);
            }
        }
        playlistService.appendToPlaylist(playlistId, mediaFileIds, function (){
            parent.left.updatePlaylists();
            $().toastmessage("showSuccessToast", "<fmt:message key="playlist.toast.appendtoplaylist"/>");
        });
    }

    function playQueueCallback(playQueue) {
        songs = playQueue.entries;
        repeatEnabled = playQueue.repeatEnabled;
        pandoraEnabled = playQueue.pandoraEnabled;
		
        if ($("#start")) {
            if (playQueue.stopEnabled) {
                $("#start").hide();
                $("#stop").show();
            } else {
                $("#start").show();
                $("#stop").hide();
            }
        }

		if (repeatEnabled) {
			$('.ToggleButton').attr('id', 'repeat_on');
		}
		if (pandoraEnabled) {
			$('.PandoraButton').attr('id', 'pandora_on');
        }

        if (songs.length == 0) {
            $("#empty").show();
        } else {
            $("#empty").hide();
        }

        // Delete all the rows except for the "pattern" row
        dwr.util.removeAllRows("playlistBody", { filter:function(tr) {
            return (tr.id != "pattern");
        }});

        // Create a new set cloned from the pattern row
        for (var i = 0; i < songs.length; i++) {
            var song  = songs[i];
            var id = i + 1;
            dwr.util.cloneNode("pattern", { idSuffix:id });
            if ($("#trackNumber" + id)) {
                $("#trackNumber" + id).html(song.trackNumber);
            }
            if (song.starred) {
                $("#starSong" + id).attr("src", "<spring:theme code='ratingOnImage'/>");
            } else {
                $("#starSong" + id).attr("src", "<spring:theme code='ratingOffImage'/>");
            } 
			
			$("#currentIndex" + id).html(i);
            $("#currentIndex" + id).hide();
			
            if ($("#currentImage" + id) && song.streamUrl == currentStreamUrl) {
                $("#currentImage" + id).show();
            }
            if ($("#title" + id)) {
                $("#title" + id).html(truncate(song.title));
                $("#title" + id).attr("title", song.title);
            }
            if ($("#titleUrl" + id)) {
                $("#titleUrl" + id).html(truncate(song.title));
                $("#titleUrl" + id).attr("title", song.title);
                $("#titleUrl" + id).click(function () {onSkip(this.id.substring(8) - 1)});
            }
            if ($("#album" + id)) {
                $("#album" + id).html(truncate(song.album));
                $("#album" + id).attr("title", song.album);
                $("#albumUrl" + id).attr("href", song.albumUrl);
            }
            if ($("#artist" + id)) {
                $("#artist" + id).html(truncate(song.artist));
                $("#artist" + id).attr("title", song.artist);
            }
            if ($("#genre" + id)) {
                $("#genre" + id).html(song.genre);
            }
            if ($("#mood" + id)) {
                $("#mood" + id).html(song.mood);
            }
            if ($("#year" + id)) {
                $("#year" + id).html(song.year);
            }
            if ($("#bitRate" + id)) {
                $("#bitRate" + id).html(song.bitRate);
            }
            if ($("#duration" + id)) {
                $("#duration" + id).html(song.durationAsString);
            }
            if ($("#format" + id)) {
                $("#format" + id).html(song.format);
            }
            if ($("#fileSize" + id)) {
                $("#fileSize" + id).html(song.fileSize);
            }

            $("#pattern" + id).addClass((i % 2 == 0) ? "bgcolor1" : "bgcolor2");
            // Note: show() method causes page to scroll to top.
            $("#pattern" + id).css("display", "table-row");
        }

        if (playQueue.sendM3U) {
            parent.frames.main.location.href="play.m3u?";
        }

        if (slider) {
            slider.setValue(playQueue.gain * 100);
        }

    <c:if test="${model.player.web}">
        triggerPlayer();
    </c:if>
    }

    function triggerPlayer() {
        if (startPlayer) {
            startPlayer = false;

        if (PlayLast) {
            PlayLast = false;

		   if (songs.length > 0) {
		   skip(songs.length -1);
		   }
		}
		else {
		   if (songs.length > 0) {
		   skip(0);
		   }
		}

        }
        updateCurrentImage();
        if (songs.length == 0) {
            player.sendEvent("LOAD", new Array());
            player.sendEvent("STOP");
        }
    }

function skip(index) {
        if (index < 0 || index >= songs.length) {
            return;
        }

        var song = songs[index];
        var saltedUrl = song.streamUrl + "&salt=" + Math.floor(Math.random()*100000);
        currentStreamUrl = song.streamUrl;
		currentStreamIndex = song.streamUrl + "&index=" + index;
		
        updateCurrentImage();
        var list = new Array();
        list[0] = {
            file:saltedUrl,
            title:song.title,
            provider:"sound"
        };

        if (song.duration != null) {
            list[0].duration = song.duration;
        }
        if (song.format == "aac" || song.format == "m4a") {
            list[0].provider = "video";
        }

        player.sendEvent("LOAD", list);
        player.sendEvent("PLAY");
        
        setNotification(song);
    }


    function updateCurrentImage() {
        for (var i = 0; i < songs.length; i++) {
            var song  = songs[i];
            var id = i + 1;
            var image = $("#currentImage" + id);

            if (image) {
                if (song.streamUrl + "&index=" + i == currentStreamIndex ) {
				
					
                    image.show();
					
                } else {
                    image.hide();
                }
            }
        }
    }

    function getCurrentSongIndex() {
        for (var i = 0; i < songs.length; i++) {
            if (songs[i].streamUrl + "&index=" + i  == currentStreamIndex ) {
                return i;
            }
        }
        return -1;
    }

    function truncate(s) {
        if (s == null) {
            return s;
        }
        var cutoff = ${model.visibility.captionCutoff};

        if (s.length > cutoff) {
            return s.substring(0, cutoff) + "...";
        }
        return s;
    }

    <!-- actionSelected() is invoked when the users selects from the "More actions..." combo box. -->
    function actionSelected(id) {
        if (id == "top") {
            return;
        } else if (id == "savePlaylist") {
            onSavePlaylist();
        } else if (id == "downloadPlaylist") {
            location.href = "download.view?player=${model.player.id}";
        } else if (id == "sharePlaylist") {
            parent.frames.main.location.href = "createShare.view?player=${model.player.id}&" + getSelectedIndexes();
        } else if (id == "sortByTrack") {
            onSortByTrack();
        } else if (id == "sortByArtist") {
            onSortByArtist();
        } else if (id == "sortByAlbum") {
            onSortByAlbum();
        } else if (id == "selectAll") {
            selectAll(true);
        } else if (id == "selectNone") {
            selectAll(false);
        } else if (id == "removeSelected") {
            onRemoveSelected();
        } else if (id == "download") {
            location.href = "download.view?player=${model.player.id}&" + getSelectedIndexes();
        } else if (id == "appendPlaylist") {
            onAppendPlaylist();
        }
        $("#moreActions").prop("selectedIndex", 0);
    }

    function getSelectedIndexes() {
        var result = "";
        for (var i = 0; i < songs.length; i++) {
            if ($("#songIndex" + (i + 1)).is(":checked")) {
                result += "i=" + i + "&";
            }
        }
        return result;
    }

    function selectAll(b) {
        for (var i = 0; i < songs.length; i++) {
            if (b) {
                $("#songIndex" + (i + 1)).attr("checked", "checked");
            } else {
                $("#songIndex" + (i + 1)).removeAttr("checked");
			}
		}
    }
</script>

<!-- content block -->

				<div id="content_3" class="content_playqueue">
				<!-- CONTENT -->			
				<div class="bgcolor2" style="position:fixed; top:0; left:0; width:100%; padding-top:0.1em; margin-left:6px;z-index:1000;">
				<table style="border-collapse: collapse;" class="123">
						 <tr style="white-space:nowrap; margin: 0 0 0.1em 0; padding: 0;">
						<c:if test="${model.user.settingsRole}">
							<td><select name="player" onchange="location='playQueue.view?player=' + options[selectedIndex].value;">
								<c:forEach items="${model.players}" var="player">
									<option ${player.id eq model.player.id ? "selected" : ""} title='${player.ipAddress}' value="${player.id}">${player.shortDescription}</option>
								</c:forEach>
							</select>
						</td>
						</c:if>
						<c:if test="${model.player.web}">
							<c:if test="${not model.user.settingsRole}">
								<td style="width:340px; height:24px;padding-left:0px;padding-right:0px"><div id="placeholder">
							</c:if>
							<c:if test="${model.user.settingsRole}">
								<td style="width:340px; height:24px;padding-left:10px;padding-right:0px"><div id="placeholder">
							</c:if>
							<a href="http://www.adobe.com/go/getflashplayer" target="_blank"><fmt:message key="playlist.getflash"/></a>
							</div></td>
						</c:if>
						<c:if test="${model.user.streamRole and not model.player.web}">
                <td style="white-space:nowrap;padding-left:1.0em;" id="stop"><b><a href="javascript:void(0)" onclick="onStop()" id="play1"><fmt:message key="playlist.stop"/></a></b></td>
                <td style="white-space:nowrap;padding-left:1.0em;" id="start"><b><a href="javascript:void(0)" onclick="onStart()" id="stop1"><fmt:message key="playlist.start"/></a></b></td>
						</c:if>

						<c:if test="${model.player.jukebox}">
							<td style="white-space:nowrap;">
								<img src="<spring:theme code="volumeImage"/>" alt="">
							</td>
							<td style="white-space:nowrap;">
								<div class="slider bgcolor2" id="slider-1" style="width:90px">
									<input class="slider-input" id="slider-input-1" name="slider-input-1">
								</div>
								<script type="text/javascript">

									var updateGainTimeoutId = 0;
									slider = new Slider(document.getElementById("slider-1"), document.getElementById("slider-input-1"));
									slider.onchange = function () {
										clearTimeout(updateGainTimeoutId);
										updateGainTimeoutId = setTimeout("updateGain()", 250);
									};

									function updateGain() {
										var gain = slider.getValue() / 100.0;
										onGain(gain);
									}
								</script>
							</td>
						</c:if>

						<c:if test="${model.player.web}">
							<td style="white-space:nowrap;"><a href="javascript:void(0)" onclick="onPrevious()" id="rewind1" title="Rewind"></a></td>
							<td style="white-space:nowrap;"><a href="javascript:void(0)" onclick="onNext(false)" id="forward1" title="Forward"></a></td>
						 </c:if>

						<td style="white-space:nowrap;"><a href="javascript:void(0)" onclick="onClear()" id="clear1" title="Clear"><fmt:message key="playlist.clear"/></a></td>
						<td style="white-space:nowrap;"><a href="javascript:void(0)" onclick="onShuffle()" id="shuffle" title="Shuffle"><fmt:message key="playlist.shuffle"/></a></td>

						<c:if test="${model.player.web or model.player.jukebox or model.player.external}">
						<td style="white-space:nowrap;"><a href="javascript:void(0)" onclick="onToggleRepeat()" title="Repeat" class="ToggleButton" id="repeat_off"><span id="onToggleRepeat" class="handcursor"></span>
						</a></td>
						</c:if>
						
						<td style="white-space:nowrap;"><a href="javascript:void(0)" onclick="onUndo()" title="Undo" id="undo"><fmt:message key="playlist.undo"/></a></td>

						<c:if test="${model.player.web}">
						 <td style="white-space:nowrap;"><a href="javascript:void(0)" onclick="onTogglePandora()" title="Pandora Mode" class="PandoraButton" id="pandora_off"><span id="onTogglePandora" class="handcursor"></span>
						</c:if>

						<c:if test="${model.user.settingsRole}">
						   <td style="white-space:nowrap;padding-right:10px;"><a href="playerSettings.view?id=${model.player.id}" target="main" title="Settings" id="settings1">Settings</a></td>
						</c:if>

						<td style="white-space:nowrap;padding-left:0.5em;"><select id="moreActions" onchange="actionSelected(this.options[selectedIndex].id)">
							<option id="top" selected="selected"><fmt:message key="playlist.more"/></option>
							<option style="color:blue;"><fmt:message key="playlist.more.playlist"/></option>
							<option id="savePlaylist">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="playlist.save"/></option>
							<c:if test="${model.user.downloadRole}">
								<option id="downloadPlaylist">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="common.download"/></option>
							</c:if>
							<c:if test="${model.user.shareRole}">
								<option id="sharePlaylist">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="main.more.share"/></option>
							</c:if>
							<option id="sortByTrack">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="playlist.more.sortbytrack"/></option>
							<option id="sortByAlbum">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="playlist.more.sortbyalbum"/></option>
							<option id="sortByArtist">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="playlist.more.sortbyartist"/></option>
							<option style="color:blue;"><fmt:message key="playlist.more.selection"/></option>
							<option id="selectAll">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="playlist.more.selectall"/></option>
							<option id="selectNone">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="playlist.more.selectnone"/></option>
							<option id="removeSelected">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="playlist.remove"/></option>
							<c:if test="${model.user.downloadRole}">
								<option id="download">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="common.download"/></option>
							</c:if>
							<option id="appendPlaylist">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="playlist.append"/></option>
						</select>
						</td>

					</tr></table>
				</div>
				<div style="height:3.0em"></div>
				<p id="empty"><em><fmt:message key="playlist.empty"/></em></p>
				<table style="border-collapse:collapse;white-space:nowrap;">
				<tbody id="playlistBody">
					<tr id="pattern" style="display:none;margin:0;padding:0;border:0">
						<td class="bgcolor2"><a href="javascript:void(0)">
							<img id="starSong" class="starSong" onclick="onStar(this.id.substring(8) - 1)" src="<spring:theme code="ratingOffImage"/>"
								 alt="" title="Star"></a></td>
						<td class="bgcolor2"><a href="javascript:void(0)">
							<img id="removeSong" onclick="onRemove(this.id.substring(10) - 1)" src="<spring:theme code="removeImage"/>"
								 alt="<fmt:message key="playlist.remove"/>" title="<fmt:message key="playlist.remove"/>">&nbsp;</a></td>
						<td class="bgcolor2"><a href="javascript:void(0)">
							<img id="up" onclick="onUp(this.id.substring(2) - 1)" src="<spring:theme code="upImage"/>"
								 alt="<fmt:message key="playlist.up"/>" title="<fmt:message key="playlist.up"/>">&nbsp;</a></td>
						<td class="bgcolor2"><a href="javascript:void(0)">
							<img id="down" onclick="onDown(this.id.substring(4) - 1)" src="<spring:theme code="downImage"/>"
								 alt="<fmt:message key="playlist.down"/>" title="<fmt:message key="playlist.down"/>">&nbsp;</a></td>

						<td class="bgcolor2" style="padding-left: 0.1em"><input type="checkbox" class="checkbox" id="songIndex"></td>
						<td style="padding-right:1.0em"></td>

						<td><span class="detail" id="currentIndex"> </span></td>
						
						<c:if test="${model.visibility.trackNumberVisible}">
							<td style="padding-right:0.5em;text-align:right"><span class="detail" id="trackNumber">1</span></td>
						</c:if>

						<td style="padding-right:1.25em">
							<img id="currentImage" src="<spring:theme code="currentImage"/>" alt="" style="display:none">
							<c:choose>
								<c:when test="${model.player.externalWithPlaylist}">
									<span id="title">Title</span>
								</c:when>
								<c:otherwise>
                        <a id="titleUrl" href="javascript:void(0)">Title</a>
								</c:otherwise>
							</c:choose>
						</td>

						<c:if test="${model.visibility.albumVisible}">
							<td style="padding-right:1.25em"><a id="albumUrl" target="main"><span id="album" class="detail">Album</span></a></td>
						</c:if>
						<c:if test="${model.visibility.artistVisible}">
							<td style="padding-right:1.25em"><span id="artist" class="detail">Artist</span></td>
						</c:if>
						<c:if test="${model.visibility.moodVisible}">
							<td style="padding-right:1.25em"><span id="mood" class="detail">Mood</span></td>
						</c:if>
						<c:if test="${model.visibility.genreVisible}">
							<td style="padding-right:1.25em"><span id="genre" class="detail">Genre</span></td>
						</c:if>
						<c:if test="${model.visibility.yearVisible}">
							<td style="padding-right:1.25em"><span id="year" class="detail">Year</span></td>
						</c:if>
						<c:if test="${model.visibility.formatVisible}">
							<td style="padding-right:1.25em"><span id="format" class="detail">Format</span></td>
						</c:if>
						<c:if test="${model.visibility.fileSizeVisible}">
							<td style="padding-right:1.25em;text-align:right;"><span id="fileSize" class="detail">Format</span></td>
						</c:if>
						<c:if test="${model.visibility.durationVisible}">
							<td style="padding-right:1.25em;text-align:right;"><span id="duration" class="detail">Duration</span></td>
						</c:if>
						<c:if test="${model.visibility.bitRateVisible}">
							<td style="padding-right:0.25em"><span id="bitRate" class="detail">Bit Rate</span></td>
						</c:if>
					</tr>
				</tbody>
			</table>

			<div id="dialog-select-playlist" title="<fmt:message key="main.addtoplaylist.title"/>" style="display: none;">
				<p><fmt:message key="main.addtoplaylist.text"/></p>
				<div id="dialog-select-playlist-list"></div>
			</div>
			<!-- CONTENT -->
</div>

<c:if test="${model.customScrollbar}">
<script>

		(function($){
			$(window).load(function(){
				$("#content_3").mCustomScrollbar({
					set_width:false, /*optional element width: boolean, pixels, percentage*/
					set_height:false, /*optional element height: boolean, pixels, percentage*/
					horizontalScroll:false, /*scroll horizontally: boolean*/
					scrollInertia:550, /*scrolling inertia: integer (milliseconds)*/
					mouseWheel:true, /*mousewheel support: boolean*/
					mouseWheelPixels:"auto", /*mousewheel pixels amount: integer, "auto"*/
					autoDraggerLength:true, /*auto-adjust scrollbar dragger length: boolean*/
					autoHideScrollbar:false, /*auto-hide scrollbar when idle*/
					scrollButtons:{ /*scroll buttons*/
						enable:true, /*scroll buttons support: boolean*/
						scrollType:"continuous", /*scroll buttons scrolling type: "continuous", "pixels"*/
						scrollSpeed:"auto", /*scroll buttons continuous scrolling speed: integer, "auto"*/
						scrollAmount:120 /*scroll buttons pixels scroll amount: integer (pixels)*/
					},
					advanced:{
						updateOnBrowserResize:true, /*update scrollbars on browser resize (for layouts based on percentages): boolean*/
						updateOnContentResize:true, /*auto-update scrollbars on content resize (for dynamic content): boolean*/
						autoExpandHorizontalScroll:false, /*auto-expand width for horizontal scrolling: boolean*/
						autoScrollOnFocus:false, /*auto-scroll on focused elements: boolean*/
						normalizeMouseWheelDelta:true /*normalize mouse-wheel delta (-1/1)*/
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

$(".content_playqueue").resize(function(e){
	$(".content_playqueue").mCustomScrollbar("update");
});

</script>
</c:if>	

<script>
$('.ToggleButton').click(function(){
	switch(this.id)
	{
	case "repeat_off":
		$(this).attr('id', 'repeat_on');
	  break;
	case "repeat_on":
		$(this).attr('id', 'repeat_off');
	  break;
	}
});
$('.PandoraButton').click(function(){
	switch(this.id)
	{
	case "pandora_off":
		$(this).attr('id', 'pandora_on');
	  break;
	case "pandora_on":
		$(this).attr('id', 'pandora_off');
	  break;
	}
});
</script>
</body></html>