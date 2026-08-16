import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../data/mock_data.dart';
import '../../data/app_state.dart';
import '../../models/models.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});
  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final _messages = AppState.instance.inboxMessages;
  int get _unread => _messages.where((m) => !m.isRead).length;

  void _open(InboxMessage m) {
    setState(() => m.isRead = true);
    if (m.isNotification) {
      _showNotification(m);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => _MessageThreadScreen(message: m)));
    }
  }

  void _showNotification(InboxMessage m) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          Row(children: [
            CircleAvatar(radius: 22, backgroundColor: AppColors.primaryDark,
              child: Text(m.avatarInitials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(m.sender, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
              Text(m.timeAgo, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
            ])),
            const Icon(Icons.notifications_outlined, color: AppColors.primaryDark, size: 22),
          ]),
          const SizedBox(height: 14),
          Text(m.subject, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Text(m.preview, style: const TextStyle(fontSize: 13, color: AppColors.textMed, height: 1.6)),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity,
            child: ElevatedButton(onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(vertical: 12)),
              child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold)))),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: Column(children: [
        Container(
          color: AppColors.primaryDark,
          padding: EdgeInsets.fromLTRB(16, top + 16, 16, 16),
          child: Row(children: [
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Inbox', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              Text('Messages & Notifications', style: TextStyle(color: Colors.white60, fontSize: 11)),
            ])),
            if (_unread > 0)
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: AppColors.badgeRed, borderRadius: BorderRadius.circular(20)),
                child: Text('$_unread new', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
          ]),
        ),
        if (_unread > 0)
          Container(
            color: AppColors.primaryLight,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('$_unread unread', style: const TextStyle(fontSize: 12, color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
              GestureDetector(
                onTap: () => setState(() { for (final m in _messages) m.isRead = true; }),
                child: const Text('Mark all read', style: TextStyle(fontSize: 12, color: AppColors.primaryMed, fontWeight: FontWeight.bold))),
            ]),
          ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _messages.length,
            separatorBuilder: (_,__) => const Divider(height: 1, indent: 72),
            itemBuilder: (_, i) {
              final m = _messages[i];
              return Material(
                color: m.isRead ? AppColors.white : AppColors.primaryLight.withOpacity(0.5),
                child: InkWell(
                  splashColor: AppColors.primaryDark.withOpacity(0.08),
                  onTap: () => _open(m),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      CircleAvatar(radius: 22,
                        backgroundColor: m.isRead ? AppColors.divider : AppColors.primaryDark,
                        child: Text(m.avatarInitials, style: TextStyle(
                          color: m.isRead ? AppColors.textGrey : Colors.white,
                          fontSize: 11, fontWeight: FontWeight.bold))),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(m.sender, style: TextStyle(fontSize: 13,
                            fontWeight: m.isRead ? FontWeight.normal : FontWeight.bold, color: AppColors.textDark)),
                          Row(children: [
                            if (m.isNotification) const Icon(Icons.notifications_outlined, size: 13, color: AppColors.textGrey),
                            const SizedBox(width: 4),
                            Text(m.timeAgo, style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
                          ]),
                        ]),
                        const SizedBox(height: 2),
                        Text(m.subject, style: TextStyle(fontSize: 12,
                          fontWeight: m.isRead ? FontWeight.normal : FontWeight.w600, color: AppColors.textDark),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(m.preview, style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      ])),
                      if (!m.isRead) ...[const SizedBox(width: 8),
                        Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryDark))],
                    ]),
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}

class _MessageThreadScreen extends StatefulWidget {
  final InboxMessage message;
  const _MessageThreadScreen({required this.message});
  @override
  State<_MessageThreadScreen> createState() => _MessageThreadScreenState();
}

class _MessageThreadScreenState extends State<_MessageThreadScreen> {
  final _ctrl = TextEditingController();
  String? _editId;
  late final List<ChatMessage> _thread = widget.message.thread;

  void _send() {
    if (_ctrl.text.trim().isEmpty) return;
    setState(() {
      if (_editId != null) {
        final c = _thread.firstWhere((c) => c.id == _editId);
        _thread[_thread.indexOf(c)] = ChatMessage(id: c.id, text: _ctrl.text.trim(), isMe: c.isMe, time: c.time);
        _editId = null;
      } else {
        _thread.add(ChatMessage(
          id: 'msg${DateTime.now().millisecondsSinceEpoch}',
          text: _ctrl.text.trim(), isMe: true, time: 'Just now'));
      }
      _ctrl.clear();
    });
  }

  void _deleteMsg(ChatMessage m) => setState(() => _thread.remove(m));

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white, elevation: 0,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.message.sender, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text(widget.message.subject, style: const TextStyle(fontSize: 11, color: Colors.white70), maxLines: 1, overflow: TextOverflow.ellipsis),
        ]),
      ),
      body: Column(children: [
        Expanded(
          child: _thread.isEmpty
            ? const Center(child: Text('No messages yet.', style: TextStyle(color: AppColors.textGrey)))
            : ListView.builder(
                padding: const EdgeInsets.all(16), itemCount: _thread.length,
                itemBuilder: (_, i) {
                  final m = _thread[i];
                  return Align(
                    alignment: m.isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: GestureDetector(
                      onLongPress: m.isMe ? () => showModalBottomSheet(context: context,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                        builder: (_) => Column(mainAxisSize: MainAxisSize.min, children: [
                          ListTile(leading: const Icon(Icons.edit_outlined, color: AppColors.primaryDark),
                            title: const Text('Edit'), onTap: () { Navigator.pop(context); setState(() { _editId = m.id; _ctrl.text = m.text; }); }),
                          ListTile(leading: const Icon(Icons.delete_outline, color: Colors.red),
                            title: const Text('Delete', style: TextStyle(color: Colors.red)),
                            onTap: () { Navigator.pop(context); _deleteMsg(m); }),
                        ])) : null,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                        decoration: BoxDecoration(
                          color: m.isMe ? AppColors.primaryDark : AppColors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: m.isMe ? null : Border.all(color: AppColors.divider)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Text(m.text, style: TextStyle(fontSize: 13, color: m.isMe ? Colors.white : AppColors.textDark, height: 1.4)),
                          const SizedBox(height: 3),
                          Text(m.time, style: TextStyle(fontSize: 9, color: m.isMe ? Colors.white60 : AppColors.textGrey)),
                        ]),
                      ),
                    ),
                  );
                },
              ),
        ),
        const Divider(height: 1),
        Padding(
          padding: EdgeInsets.fromLTRB(12, 8, 12, MediaQuery.of(context).viewInsets.bottom + 16),
          child: Row(children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.divider)),
                child: TextField(
                  controller: _ctrl,
                  style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                  decoration: InputDecoration(
                    hintText: _editId != null ? 'Edit message…' : 'Type a reply…',
                    hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 12),
                    border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(color: AppColors.primaryDark, shape: const CircleBorder(),
              child: InkWell(customBorder: const CircleBorder(), onTap: _send,
                child: const Padding(padding: EdgeInsets.all(11), child: Icon(Icons.send, color: Colors.white, size: 18)))),
          ]),
        ),
      ]),
    );
  }
}
