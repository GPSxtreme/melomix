import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:just_audio/just_audio.dart';

import '../services/player_buttons.dart';

class PlayerController extends StatefulWidget {
  PlayerController(this.audioPlayer, {super.key, required this.isFullScreen, required this.shuffleBtnSize, required this.prevBtnSize, required this.playPauseBtnSize, required this.nextBtnSize, required this.repeatBtnSize, this.ppBtnColor, this.ppBtnPlayIcon, this.ppBtnPauseIcon, this.ppBtnReplayIcon, this.shuffleBtnIcon, this.shuffleBtnActiveColor, this.shuffleBtnDisableColor, this.prevBtnIcon, this.prevBtnHexActiveColor, this.prevBtnHexDisableColor, this.nextBtnIcon, this.nextBtnHexActiveColor, this.nextBtnHexDisableColor, this.repeatBtnIcon, this.repeatBtnOneIcon , this.repeatBtnHexColor, this.repeatBtnHexRepeatColor, this.repeatBtnHexRepeatOneColor,});
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
        if(widget.isFullScreen)
        StreamBuilder(
            stream: widget.audioPlayer.createPositionStream(),
          builder: (context,AsyncSnapshot<Duration> snapshot){
              if(widget.audioPlayer.duration != null && snapshot.data != null){
                double streamDuration = widget.audioPlayer.duration!.inSeconds.toDouble();
                return SizedBox(
                  height: 10,
                  child: Slider(
                    // thumbColor:Colors.black,
                    // activeColor: HexColor("111111"),
                    // inactiveColor: HexColor("7a7a7a"),
                    min: 0.0,
                    max: streamDuration,
                    value: snapshot.data!.inSeconds.toDouble(),
                    onChanged: (value) async{
                      await widget.audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                );
              } else {
                return const SizedBox(height: 0,);
              }
          }
        ),
        const SizedBox(height: 10,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(widget.isFullScreen) ...[
              StreamBuilder<bool>(
                stream: widget.audioPlayer.shuffleModeEnabledStream,
                builder: (context, snapshot) {
                  return PlayerButtons.shuffleButton(context, snapshot.data ?? false , widget.audioPlayer, widget.shuffleBtnSize,
                      hexActiveColor: widget.shuffleBtnActiveColor,
                      hexDisableColor: widget.shuffleBtnDisableColor,
                      shuffleIcon: widget.shuffleBtnIcon
                  );
                },
              ),
              const SizedBox(width: 15,),
            ],
            StreamBuilder<SequenceState?>(
              stream: widget.audioPlayer.sequenceStateStream,
              builder: (_, __) {
                if(widget.audioPlayer.hasPrevious || widget.isFullScreen) {
                  return PlayerButtons.previousButton(widget.audioPlayer,widget.prevBtnSize,
                hexDisableColor: widget.prevBtnHexDisableColor,
                  hexActiveColor: widget.prevBtnHexActiveColor,
                    prevIcon: widget.prevBtnIcon
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
                    return PlayerButtons.playPauseButton(widget.audioPlayer,playerState,widget.playPauseBtnSize,
                    iconColorHex: widget.ppBtnColor,
                      pauseIcon: widget.ppBtnPlayIcon,
                      playIcon: widget.ppBtnPlayIcon,
                      replayIcon: widget.ppBtnReplayIcon
                    );
                  }else {
                    return const Text("n/a");
                  }
              },
            ),
            SizedBox(width: widget.isFullScreen ? 10 : 5,),
            StreamBuilder<SequenceState?>(
              stream: widget.audioPlayer.sequenceStateStream,
              builder: (_, __) {
                if(widget.audioPlayer.hasNext || widget.isFullScreen) {
                  return PlayerButtons.nextButton(widget.audioPlayer,widget.nextBtnSize,
                hexActiveColor: widget.nextBtnHexActiveColor,
                  hexDisableColor: widget.nextBtnHexDisableColor,
                  nextIcon: widget.nextBtnIcon
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
                  return PlayerButtons.repeatButton(context, snapshot.data ?? LoopMode.off,widget.audioPlayer,widget.repeatBtnSize,
                      hexColor: widget.repeatBtnHexColor,
                      hexRepeatColor: widget.repeatBtnHexRepeatColor,
                      hexRepeatOneColor: widget.repeatBtnHexRepeatOneColor,
                      repeatIcon: widget.repeatBtnIcon,
                      repeatOneIcon: widget.repeatBtnOneIcon
                  );
                },
              ),
            ]
          ],
        ),
      ],
    );
  }


}