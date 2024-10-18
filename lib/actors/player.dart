import 'dart:async';
import 'package:dino_run/pixel_adventure.dart';
import 'package:flame/components.dart';

enum PlayerState { idle, running, jumping, falling }

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure> {
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final String character;
  final double stepTime = 0.05;

  PlayerDirection direction = PlayerDirection.left;

  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();

  Player({required this.character});

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerPosition(dt);
    super.update(dt);
  }

  void _loadAllAnimations() {
    idleAnimation = _getSpriteAnimation('Idle', 11);

    runningAnimation = _getSpriteAnimation('Run', 12);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };

    current = PlayerState.running;
  }

  SpriteAnimation _getSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void _updatePlayerPosition(double dt) {
    double dirX = 0.0;

    switch (direction) {
      case PlayerDirection.left:
        dirX = -1.0;
        break;
      case PlayerDirection.right:
        dirX = 1.0;
        break;
      case PlayerDirection.none:
        break;
    }

    velocity = Vector2(dirX, 0.0);
    position += velocity * moveSpeed * dt;
  }
}
