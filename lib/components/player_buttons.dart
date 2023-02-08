import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:just_audio/just_audio.dart';

import '../services/player_buttons.dart';

class PlayerController extends StatefulWidget {
  PlayerController(this.audioPlayer, {super.key, required this.isFullScreen, required this.shuffleBtnSize, required this.prevBtnSize, required this.playPauseBtnSize, required this.nextBtnSize, required this.repeatBtnSize, this.ppBtnColor, this.ppBtnPlayIcon, this.ppBtnPauseIcon, this.ppBtnReplayIcon, this.shuffleBtnIcon, this.shuffleBtnActiveColor, this.shuffleBtnDisableColor, this.prevBtnIcon, this.prevBtnHexActiveColor, this.prevBtnHexDisableColor, this.nextBtnIcon, this.nextBtnHexActiveColor, this.nextBtnHexDisableColor, this.repeatBtnIcon, this.repeatBtnOneIcon , this.repeatBtnHexColor, this.repeatBtnHexRepeatColor, this.repeatBtnHexRepeatOneColor});
  //required data
  final AudioPlayer audioPlayer;
  final bool isFullScreen;
  final double shuffleBtnSize;
  final double prevBtnSize;
  final double playPauseBtnSize;
  final double nextBtnSize;
  final double repeatBtnSize;
  //------optional data------
  //play pause replay button data
  final HexColor? ppBtnColor;
  final IconData? ppBtnPlayIcon;
  final IconData? ppBtnPauseIcon;
  final IconData? ppBtnReplayIcon;
  //shuffle button data
  final IconData? shuffleBtnIcon;
  final HexColor? shuffleBtnActiveColor;
  final HexColor? shuffleBtnDisableColor;
  //previous button data
  final IconData? prevBtnIcon;
  final HexColor? prevBtnHexActiveColor;
  final HexColor? prevBtnHexDisableColor;
  //next button data
  final IconData? nextBtnIcon;
  final HexColor? nextBtnHexActiveColor;
  final HexColor? nextBtnHexDisableColor;
  //repeat button data
  final IconData? repeatBtnIcon;
  IconData? repeatBtnOneIcon;
  final HexColor? repeatBtnHexColor;
  final HexColor? repeatBtnHexRepeatColor;
  final HexColor? repeatBtnHexRepeatOneColor;
  @override
  State<PlayerController> createState() => _PlayerControllerState();
}

class _PlayerControllerState extends State<PlayerController> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(widget.isFullScreen) ...[
              StreamBuilder<bool>(
                stream: widget.audioPlayer.shuffleModeEnabledStream,
                builder: (context, snapshot) {
                  return Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                    child: InkWell(
                      onTap: (){},
                      borderRadius: BorderRadius.circular(999),
                      child: Padding(
                        padding:  widget.isFullScreen ? const EdgeInsets.all(8.0) : const EdgeInsets.all(3.0),
                        child: PlayerButtons.shuffleButton(context, snapshot.data ?? false , widget.audioPlayer, widget.shuffleBtnSize,
                            hexActiveColor: widget.shuffleBtnActiveColor,
                            hexDisableColor: widget.shuffleBtnDisableColor,
                            shuffleIcon: widget.shuffleBtnIcon
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 15,),
            ],
            StreamBuilder<SequenceState?>(
              stream: widget.audioPlayer.sequenceStateStream,
              builder: (_, __) {
                if(widget.audioPlayer.hasPrevious || widget.isFullScreen) {
                  return Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                    child: InkWell(
                      onTap: (){},
                      borderRadius: BorderRadius.circular(999),
                      child: Padding(
                        padding:  widget.isFullScreen ? const EdgeInsets.all(8.0) : const EdgeInsets.all(3.0),
                        child: PlayerButtons.previousButton(widget.audioPlayer,widget.prevBtnSize,
                         hexDisableColor: widget.prevBtnHexDisableColor,
                        hexActiveColor: widget.prevBtnHexActiveColor,
                          prevIcon: widget.prevBtnIcon
                ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox(height: 0,);
                }
              },
            ),
            SizedBox(width: widget.isFullScreen ? 10 : 5,),
            StreamBuilder<PlayerState>(
              stream: widget.audioPlayer.playerStateStream,
              builder: (_, snapshot) {
                  final playerState = snapshot.data;
                  if(playerState != null) {
                    return Material(
                      elevation: 100,
                      borderRadius: BorderRadius.circular(999),
                      color:widget.isFullScreen ? Colors.blue[400]:Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.white70,
                        onTap: (){},
                        borderRadius: BorderRadius.circular(999),
                        child: Padding(
                          padding: widget.isFullScreen ? const EdgeInsets.all(10.0) : const EdgeInsets.all(3.0),
                          child: Material(
                            elevation: 80,
                            color: Colors.transparent,
                            child: PlayerButtons.playPauseButton(widget.audioPlayer,playerState,widget.playPauseBtnSize,
                            iconColorHex: widget.ppBtnColor,
                              pauseIcon: widget.ppBtnPlayIcon,
                              playIcon: widget.ppBtnPlayIcon,
                              replayIcon: widget.ppBtnReplayIcon
                            ),
                          ),
                        ),
                      ),
                    );
                  }else {
                    return const SizedBox();
                  }
              },
            ),
            SizedBox(width: widget.isFullScreen ? 10 : 5,),
            StreamBuilder<SequenceState?>(
              stream: widget.audioPlayer.sequenceStateStream,
              builder: (_, __) {
                if(widget.audioPlayer.hasNext || widget.isFullScreen) {
                  return Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                    child: InkWell(
                      onTap: (){},
                      borderRadius: BorderRadius.circular(999),
                      child: Padding(
                        padding:  widget.isFullScreen ? const EdgeInsets.all(8.0) : const EdgeInsets.all(3.0),
                        child: PlayerButtons.nextButton(widget.audioPlayer,widget.nextBtnSize,
                        hexActiveColor: widget.nextBtnHexActiveColor,
                        hexDisableColor: widget.nextBtnHexDisableColor,
                        nextIcon: widget.nextBtnIcon
                ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox(height: 0,);
                }
              },
            ),
            if(widget.isFullScreen) ...[
              const SizedBox(width: 15,),
              StreamBuilder<LoopMode>(
                stream: widget.audioPlayer.loopModeStream,
                builder: (context, snapshot) {
                  return Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                    child: InkWell(
                      onTap: (){},
                      borderRadius: BorderRadius.circular(999),
                      child: Padding(
                        padding:  widget.isFullScreen ? const EdgeInsets.all(8.0) : const EdgeInsets.all(3.0),
                        child: PlayerButtons.repeatButton(context, snapshot.data ?? LoopMode.off,widget.audioPlayer,widget.repeatBtnSize,
                            hexColor: widget.repeatBtnHexColor,
                            hexRepeatColor: widget.repeatBtnHexRepeatColor,
                            hexRepeatOneColor: widget.repeatBtnHexRepeatOneColor,
                            repeatIcon: widget.repeatBtnIcon,
                            repeatOneIcon: widget.repeatBtnOneIcon
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
        if(widget.isFullScreen) ...[
          StreamBuilder(
              stream: widget.audioPlayer.createPositionStream(),
              builder: (context,AsyncSnapshot<Duration> snapshot){
                if(widget.audioPlayer.duration != null && snapshot.data != null){
                  double streamDuration = widget.audioPlayer.duration!.inSeconds.toDouble();
                  return SliderTheme(
                    data: SliderThemeData(
                      thumbColor: Colors.blue[400],
                      activeTrackColor: Colors.blue[400],
                      inactiveTrackColor: Colors.white24
                    ),
                    child: Slider(
                      min: 0.0,
                      max: streamDuration,
                      value: snapshot.data!.inSeconds.toDouble(),
                      onChanged: (value) async{
                        await widget.audioPlayer.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                  );
                } else {
                  return Slider(
                    min: 0.0, max:10 ,value: 0, onChanged: (double value) {},
                  );
                }
              }
          ),
        ],
      ],
    );
  }


}