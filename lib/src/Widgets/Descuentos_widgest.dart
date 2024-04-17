import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mi_app_optativa/src/Models/Descuentos.dart';

class DescuentosCarousel extends StatefulWidget {
  final List<Descuentos> descuentosList;
  final Duration interval;
  final double imageSize;

  DescuentosCarousel({
    required this.descuentosList,
    required this.interval,
    required this.imageSize,
  });

  @override
  _DescuentosCarouselState createState() => _DescuentosCarouselState();
}

class _DescuentosCarouselState extends State<DescuentosCarousel> {
  late Timer _timer;
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(widget.interval, (Timer timer) {
      if (_currentIndex < widget.descuentosList.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.descuentosList.length,
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemBuilder: (BuildContext context, int index) {
        Descuentos descuento = widget.descuentosList[index];
        return GestureDetector(
          onTap: () {
            // Detiene el temporizador al tocar la imagen
            _timer.cancel();
            // Muestra la imagen en pantalla completa
            _showImageFullScreen(context, descuento);
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Image.network(
              descuento.imagen,
              fit: BoxFit.cover,
              width: widget.imageSize,
              height:
                  widget.imageSize * 0.7, // Reduciendo la altura de la imagen
            ),
          ),
        );
      },
    );
  }

  void _showImageFullScreen(BuildContext context, Descuentos descuento) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image.network(descuento.imagen),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Reinicia el temporizador al cerrar la pantalla completa
                _startTimer();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
