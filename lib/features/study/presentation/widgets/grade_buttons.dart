import 'package:flutter/material.dart';

/// 4 档评分按钮
/// Again / Hard / Good / Easy
/// 对应 SM-2 算法的 quality 输入：
///   Again = 1  （答错，< 3）
///   Hard  = 3  （答对但很艰难）
///   Good  = 4  （答对，正常）
///   Easy  = 5  （答对，毫不费力）
class GradeButtons extends StatelessWidget {
  final void Function(int quality) onGrade;

  const GradeButtons({super.key, required this.onGrade});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _GradeBtn(
            label: '重来',
            sub: 'Again',
            quality: 1,
            color: Colors.red,
            onTap: onGrade,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _GradeBtn(
            label: '困难',
            sub: 'Hard',
            quality: 3,
            color: Colors.orange,
            onTap: onGrade,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _GradeBtn(
            label: '良好',
            sub: 'Good',
            quality: 4,
            color: Colors.green,
            onTap: onGrade,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _GradeBtn(
            label: '简单',
            sub: 'Easy',
            quality: 5,
            color: Colors.blue,
            onTap: onGrade,
          ),
        ),
      ],
    );
  }
}

class _GradeBtn extends StatelessWidget {
  final String label;
  final String sub;
  final int quality;
  final Color color;
  final void Function(int) onTap;

  const _GradeBtn({
    required this.label,
    required this.sub,
    required this.quality,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      style: FilledButton.styleFrom(
        backgroundColor: color.withOpacity(0.15),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: color.withOpacity(0.4)),
        ),
      ),
      onPressed: () => onTap(quality),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(sub, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}
