import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:just_audio/just_audio.dart';

class PlayerButtons{
  static Widget playPauseButton(AudioPlayer player, PlayerState playerState , double iconSize ,
        {
          HexColor? iconColorHex,
          IconData? playIcon,
          IconData? pauseIcon,
          IconData? replayIcon,
        }
      )
  {
    final processingState = playerState.processingState;
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      return SpinKitRipple(
        color: Colors.white,
        size: iconSize + 16.5,
      );
    } else if (player.playing != true) {
      return GestureDetector(
        onTap:player.play,
        child: Icon(
          playIcon ?? Icons.play_arrow,color:iconColorHex ?? Colors.white,
          size: iconSize,
        ),
      );

    } else if (processingState != ProcessingState.completed) {
      return GestureDetector(
        onTap:player.pause,
        child: Icon(
          pauseIcon ?? Icons.pause,color: iconColorHex ?? Colors.white,
          size: iconSize,
        ),
      );
    } else {
      return GestureDetector(
        onTap:() =>player.seek(Duration.zero,
            index: player.effectiveIndices?.first),
        child: Icon(
          replayIcon ??  Icons.replay,color: iconColorHex ?? Colors.white,
          size: iconSize

          ,
        ),
      );
    }
  }

  static Widget shuffleButton(BuildContext context, bool isEnabled , AudioPlayer player , double iconSize,
    {
     IconData? shuffleIcon,
     HexColor? hexActiveColor,
     HexColor? hexDisableColor,
    }
  )
{
    return GestureDetector(
      onTap:() async{
        final enable = !isEnabled;
        if (enable) {
          await player.shuffle();
        }
        await player.setShuffleModeEnabled(enable);
      },
      child: Icon(
        isEnabled ? (shuffleIcon ??  Icons.shuffle):(shuffleIcon ??  Icons.shuffle ),
        color: isEnabled ? hexDisableColor ?? Colors.blue : hexActiveColor ??  Colors.white,
        size: iconSize,
      ),
    );

  }

  static Widget previousButton(AudioPlayer player , double iconSize,
      {
        IconData? prevIcon,
        HexColor? hexActiveColor,
        HexColor? hexDisableColor,
      }
    )
  {
    return GestureDetector(
      onTap:() {
        player.hasPrevious ? player.seekToPrevious() : null;
      },
      child: Icon(prevIcon ?? Icons.skip_previous,color: player.hasPrevious ? hexActiveColor ??  Colors.white : hexDisableColor ?? HexColor("#8c8c8c"),size: iconSize,),
    );
  }

  static Widget nextButton(AudioPlayer player , double iconSize,
       {
          IconData? nextIcon,
          HexColor? hexActiveColor,
          HexColor? hexDisableColor,
       }
      )
  {
    return GestureDetector(
      onTap:() {
        player.hasNext ? player.seekToNext() : null;
      },
      child: Icon(nextIcon ??  Icons.skip_next,color: player.hasNext ? hexActiveColor ??  Colors.white: hexDisableColor ?? HexColor("#8c8c8c"), size: iconSize,),
    );
  }

  static Widget repeatButton(BuildContext context, LoopMode loopMode, AudioPlayer player, double iconSize,
      {
        IconData? repeatIcon,
        IconData? repeatOneIcon,
        HexColor? hexColor,
        HexColor? hexRepeatColor,
        HexColor? hexRepeatOneColor,
      }) {
    final icons = [
      Icon(repeatIcon ?? Icons.repeat , color: Colors.white,size: iconSize,),
      Icon(repeatIcon ?? Icons.repeat, color: Colors.blue,size: iconSize,),
      Icon(repeatOneIcon ?? Icons.repeat_one, color: Colors.blue,size: iconSize,),
    ];
    const cycleModes = [
      LoopMode.off,
      LoopMode.all,
      LoopMode.one,
    ];
    final index = cycleModes.indexOf(loopMode);
    return GestureDetector(
        onTap: (){
          player.setLoopMode(
              cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
        },
        child: icons[index]
    );

  }
}