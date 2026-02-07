import 'package:flutter/material.dart';

class DoubleTapZoomWrapper extends StatefulWidget {
  final Widget child;
  final double maxScale;
  final double padding;
  final double initialScale;


  const DoubleTapZoomWrapper({
    super.key,
    required this.child,
    this.maxScale = 3.0,
    this.padding = 10.0,
    this.initialScale = 1.2
  });

  @override
  State<DoubleTapZoomWrapper> createState() => _DoubleTapZoomWrapperState();
}

class _DoubleTapZoomWrapperState extends State<DoubleTapZoomWrapper> {
  final LayerLink _link = LayerLink();
  final GlobalKey _childKey = GlobalKey();

  OverlayEntry? _overlayEntry;
  bool _zoomed = false;

  Size? _childSize;

  final TransformationController _controller =
      TransformationController();

  void _toggleZoom() {
    if (_zoomed) {
      _removeOverlay();
    } else {
      _measureAndShow();
    }

    setState(() => _zoomed = !_zoomed);
  }

  void _setInitialZoom() {

    if (_childSize == null) return;

    final double paddedWidth =
        _childSize!.width + (widget.padding * 2);
    final double paddedHeight =
        _childSize!.height + (widget.padding * 2);

    // Centering math:
    // When scaling from top-left, we must translate
    // by half the extra size to keep it centered.
    final double dx = -(paddedWidth * (widget.initialScale - 1)) / 2;
    final double dy = -(paddedHeight * (widget.initialScale - 1)) / 2;

    _controller.value = Matrix4.identity()
      ..translate(dx, dy)
      ..scale(widget.initialScale);
  }


  void _measureAndShow() {
    final renderBox =
        _childKey.currentContext!.findRenderObject() as RenderBox;

    _childSize = renderBox.size;

    _setInitialZoom();

    _showOverlay();
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Material(
          color: const Color.fromARGB(39, 0, 0, 0),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _toggleZoom,
            child: Stack(
              children: [
                CompositedTransformFollower(
                  link: _link,
                  showWhenUnlinked: false,
                  child: SizedBox(
                    width: _childSize!.width,
                    height: _childSize!.height,
                    child: InteractiveViewer(
                      clipBehavior: Clip.none,
                      transformationController: _controller,
                      constrained: false, // 👈 IMPORTANT
                      minScale: 1,
                      maxScale: widget.maxScale,
                      child: SizedBox(
                        width: _childSize!.width + (widget.padding * 2),
                        height: _childSize!.height + (widget.padding * 2),
                        child: Material(
                          elevation: 14,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: EdgeInsetsGeometry.all(widget.padding),
                            child: widget.child
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _controller.value = Matrix4.identity();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: GestureDetector(
        onDoubleTap: _toggleZoom,
        child: Opacity(
          opacity: _zoomed ? 0 : 1,
          child: Container(
            key: _childKey,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
