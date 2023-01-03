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
      return IconButton(
        icon: Icon(playIcon ?? Icons.play_arrow,color:iconColorHex ?? Colors.white,),
        iconSize: iconSize,
        onPressed: player.play,
      );
    } else if (processingState != ProcessingState.completed) {
      return IconButton(
        icon: Icon(pauseIcon ?? Icons.pause,color: iconColorHex ?? Colors.white,),
        iconSize: iconSize,
        onPressed: player.pause,
      );
    } else {
      return IconButton(
        icon: Icon(replayIcon ??  Icons.replay,color: iconColorHex ?? Colors.white,),
        iconSize: iconSize,
        onPressed: () =>player.seek(Duration.zero,
            index: player.effectiveIndices?.first),
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
    return IconButton(
      icon: isEnabled
          ? Icon(shuffleIcon ??  Icons.shuffle, color: hexDisableColor ?? Colors.blue , size: iconSize,)
          : Icon(shuffleIcon ??  Icons.shuffle , color: hexActiveColor ??  Colors.white),
      onPressed: () async {
        final enable = !isEnabled;
        if (enable) {
          await player.shuffle();
        }
        await player.setShuffleModeEnabled(enable);
      },
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
    return IconButton(
      icon: Icon(prevIcon ?? Icons.skip_previous,color: player.hasPrevious ? hexActiveColor ??  Colors.white : hexDisableColor ?? HexColor("#8c8c8c"),size: iconSize,),
      onPressed: player.hasPrevious ? player.seekToPrevious : null,
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
    return IconButton(
      icon: Icon(nextIcon ??  Icons.skip_next,color: player.hasNext ? hexActiveColor ??  Colors.white: hexDisableColor ?? HexColor("#8c8c8c"), size: iconSize,),
      onPressed: player.hasNext ? player.seekToNext : null,
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
    return IconButton(
      icon: icons[index],
      onPressed: () {
        player.setLoopMode(
            cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
      },
    );
  }
}