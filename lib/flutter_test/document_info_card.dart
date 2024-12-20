// import 'package:flutter/material.dart';

// class DocumentInfoCard extends StatefulWidget {
//   const DocumentInfoCard({super.key, required this.document, this.onPressed});

//   final List<Map<String, dynamic>> document;
//   final VoidCallback? onPressed;

//   @override
//   State<DocumentInfoCard> createState() => _DocumentInfoCardState();
// }

// class _DocumentInfoCardState extends State<DocumentInfoCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         FilledButton(
//           onPressed: widget.onPressed,
//           style: ButtonStyle(
//             maximumSize: const WidgetStatePropertyAll(Size(352, 80)),
//             backgroundColor: WidgetStatePropertyAll(_getColor()
//                 .withOpacity(_getColor() == Colors.black ? 0 : 0.5)),
//             shape: WidgetStatePropertyAll(
//               RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             shadowColor: const WidgetStatePropertyAll(Color(0x0F000000)),
//             elevation: const WidgetStatePropertyAll(4),
//           ),
//           child: ListView(
//                                       children: widget.document.map((menuItem) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       _buildIcon(),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               widget.document.type.name,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodyMedium
//                                   ?.copyWith(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                             ),
//                             // if (!(document.dataVencimento == null))
//                             //   Text(
//                             //     DateFormat('dd/MM/yyyy').format(
//                             //         document.dataVencimento ?? DateTime.now()),
//                             //     style: Theme.of(context).textTheme.bodyMedium,
//                             //   ),
//                           ],
//                         ),
//                       ),
//                       Icon(
//                         Icons.arrow_forward,
//                         color: _getColor(),
//                       ),
//                     ],
//                   ),
//                 ],
//               );
//             }
//           ),
//         ),
//       ],
//     );
//   }

//   Icon _buildIcon() {
//     final isExpired = widget.document.dataVencimento?.isBefore(DateTime.now());
//     if (isExpired == true) {
//       return const Icon(Icons.error_outline, color: Colors.red);
//     } else if (isExpired == false) {
//       return const Icon(Icons.check_circle_outline,
//           color: Colors.green);
//     } else {
//       return const Icon(Icons.pending, color: Colors.black);
//     }
//   }

//   Color _getColor() {
//     final isExpired = widget.document.dataVencimento?.isBefore(DateTime.now());
//     if (isExpired == true) {
//       return Colors.red;
//     } else if (isExpired == false) {
//       return Colors.green;
//     } else {
//       return Colors.black;
//     }
//   }
// }