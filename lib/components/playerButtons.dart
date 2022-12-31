import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PlayerButtons extends StatefulWidget {
  const PlayerButtons(this._audioPlayer, {super.key});
  final AudioPlayer _audioPlayer;

  @override
  State<PlayerButtons> createState() => _PlayerButtonsState();
}

class _PlayerButtonsState extends State<PlayerButtons> {
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
        StreamBuilder(
            stream: widget._audioPlayer.createPositionStream(),
          builder: (context,snapshot){
              if(widget._audioPlayer.duration != null && snapshot.data != null){
                double streamDuration = widget._audioPlayer.duration!.inSeconds.toDouble();
                return SizedBox(
                  height: 10,
                  child: Slider(
                    min: 0.0,
                    max: streamDuration + 2,
                    value: snapshot.data!.inSeconds.toDouble(),
                    onChanged: (value) async{
                      await widget._audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                );
              } else {
                return const SizedBox(height: 0,);
              }
          }
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<bool>(
              stream: widget._audioPlayer.shuffleModeEnabledStream,
              builder: (context, snapshot) {
                return _shuffleButton(context, snapshot.data ?? false);
              },
            ),
            StreamBuilder<SequenceState?>(
              stream: widget._audioPlayer.sequenceStateStream,
              builder: (_, __) {
                return _previousButton();
              },
            ),
            StreamBuilder<PlayerState>(
              stream: widget._audioPlayer.playerStateStream,
              builder: (_, snapshot) {
                  final playerState = snapshot.data;
                  if(playerState != null) {
                    return _playPauseButton(playerState);
                  }else {
                    return const Text("n/a");
                  }
              },
            ),
            StreamBuilder<SequenceState?>(
              stream: widget._audioPlayer.sequenceStateStream,
              builder: (_, __) {
                return _nextButton();
              },
            ),
            StreamBuilder<LoopMode>(
              stream: widget._audioPlayer.loopModeStream,
              builder: (context, snapshot) {
                return _repeatButton(context, snapshot.data ?? LoopMode.off);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _playPauseButton(PlayerState playerState) {
    final processingState = playerState.processingState;
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      return const SpinKitRipple(
        color: Colors.white,
        size: 56.5,
      );
    } else if (widget._audioPlayer.playing != true) {
      return IconButton(
        icon: const Icon(Icons.play_arrow,color: Colors.white,),
        iconSize: 40.0,
        onPressed: widget._audioPlayer.play,
      );
    } else if (processingState != ProcessingState.completed) {
      return IconButton(
        icon: const Icon(Icons.pause,color: Colors.white,),
        iconSize: 40.0,
        onPressed: widget._audioPlayer.pause,
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.replay,color: Colors.white,),
        iconSize: 40.0,
        onPressed: () => widget._audioPlayer.seek(Duration.zero,
            index: widget._audioPlayer.effectiveIndices?.first),
      );
    }
  }

  Widget _shuffleButton(BuildContext context, bool isEnabled) {
    return IconButton(
      icon: isEnabled
          ? const Icon(Icons.shuffle, color: Colors.blue)
          : const Icon(Icons.shuffle , color: Colors.white),
      onPressed: () async {
        final enable = !isEnabled;
        if (enable) {
          await widget._audioPlayer.shuffle();
        }
        await widget._audioPlayer.setShuffleModeEnabled(enable);
      },
    );
  }

  Widget _previousButton() {
    return IconButton(
      icon: Icon(Icons.skip_previous,color: widget._audioPlayer.hasNext ? Colors.white:Colors.black54,),
      onPressed: widget._audioPlayer.hasPrevious ? widget._audioPlayer.seekToPrevious : null,
    );
  }

  Widget _nextButton() {
    return IconButton(
      icon: Icon(Icons.skip_next,color: widget._audioPlayer.hasNext ? Colors.white:Colors.black54,),
      onPressed: widget._audioPlayer.hasNext ? widget._audioPlayer.seekToNext : null,
    );
  }

  Widget _repeatButton(BuildContext context, LoopMode loopMode) {
    final icons = [
      const Icon(Icons.repeat , color: Colors.white,),
      const Icon(Icons.repeat, color: Colors.blue),
      const Icon(Icons.repeat_one, color: Colors.blue),
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
        widget._audioPlayer.setLoopMode(
            cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
      },
    );
  }
}