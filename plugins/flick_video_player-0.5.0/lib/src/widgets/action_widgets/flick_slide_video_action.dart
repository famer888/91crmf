
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class FlickSlideVideoAction extends StatefulWidget {
  const FlickSlideVideoAction({
    Key? key,
    this.child,
    this.textColor = Colors.white,
    this.fontSize = 24,
    this.closeGes = false,
  }) : super(key: key);

  final Widget? child;
  final Color textColor;
  final double fontSize;
  final bool closeGes;

  @override
  State<FlickSlideVideoAction> createState() => _FlickSlideVideoActionState();
}

class _FlickSlideVideoActionState extends State<FlickSlideVideoAction> {
  Duration _duration = const Duration();
  Duration _currentPos = const Duration();
  // 滑动后值
  Duration _dargPos = const Duration();
  double updatePrevDx = 0.0;
  int updatePosX = 0;

  bool _isTouch = false;

  @override
  void initState() {
    super.initState();
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildDargProgressTime() {
    return _isTouch
        ? Container(
            height: 40,
            width: 200,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              color: Color.fromRGBO(0, 0, 0, 0.8),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                '${_duration2String(_dargPos)} / ${_duration2String(_duration)}',
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: widget.fontSize,
                ),
              ),
            ),
          )
        : Container();
  }

  String _duration2String(Duration duration) {
    if (duration.inMilliseconds < 0) return "-: negtive";

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    int inHours = duration.inHours;
    return inHours > 0
        ? "$inHours:$twoDigitMinutes:$twoDigitSeconds"
        : "$twoDigitMinutes:$twoDigitSeconds";
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    FlickVideoManager videoManager =
        Provider.of<FlickVideoManager>(context);

    _onHorizontalDragStart(DragStartDetails details) {
      if (!videoManager.isVideoInitialized || widget.closeGes) {
        return;
      }

      _currentPos = videoManager.videoPlayerValue?.position ??
          const Duration(seconds: 0);
      _duration = videoManager.videoPlayerValue?.duration ??
          const Duration(seconds: 0);

      setState(() {
        updatePrevDx = details.globalPosition.dx;
        updatePosX = _currentPos.inMilliseconds;
      });
    }

    _onHorizontalDragUpdate(DragUpdateDetails details) {
      if (!videoManager.isVideoInitialized || widget.closeGes) {
        return;
      }

      double curDragDx = details.globalPosition.dx;
      // 确定当前是前进或者后退
      int cdx = curDragDx.toInt();
      int pdx = updatePrevDx.toInt();
      bool isBefore = cdx > pdx;

      // 计算手指滑动的比例
      int newInterval = pdx - cdx;
      double playerW = MediaQuery.of(context).size.width;
      int curIntervalAbs = newInterval.abs();
      double movePropCheck = (curIntervalAbs / playerW) * 100;

      // 计算进度条的比例
      double durProgCheck = _duration.inMilliseconds.toDouble() / 100;
      int checkTransfrom = (movePropCheck * durProgCheck).toInt();
      int dragRange =
          isBefore ? updatePosX + checkTransfrom : updatePosX - checkTransfrom;

      // 是否溢出 最大
      int lastSecond = _duration.inMilliseconds;
      if (dragRange >= _duration.inMilliseconds) {
        dragRange = lastSecond;
      }
      // 是否溢出 最小
      if (dragRange <= 0) {
        dragRange = 0;
      }
    
      setState(() {
        _isTouch = true;
        // 更新下上一次存的滑动位置
        updatePrevDx = curDragDx;
        // 更新时间
        updatePosX = dragRange.toInt();
        _dargPos = Duration(milliseconds: updatePosX.toInt());
      });
    }

    _onHorizontalDragEnd(DragEndDetails details) {
      if (!videoManager.isVideoInitialized || widget.closeGes) {
        return;
      }

      videoManager.videoPlayerController?.seekTo(_dargPos);
      setState(() {
        _isTouch = false;
        _currentPos = _dargPos;
      });
    }
    
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Stack(
        children: <Widget>[
          Center(
            child: _buildDargProgressTime(),
          ),
          _isTouch 
              ? Container()
              : widget.child ?? Container(),
        ], 
      ),
    );
  }
}