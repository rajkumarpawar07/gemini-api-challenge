import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gemini_api_challenge/core/utils/app_extensions.dart';
import 'package:gemini_api_challenge/features/chatbot/application/chat_bloc.dart';
import 'package:gemini_api_challenge/features/chatbot/data/chat_data_state.dart';
import 'package:gemini_api_challenge/shared/components/gapbox.dart';
import 'package:gemini_api_challenge/features/chatbot/data/chat_data.dart';
import 'package:gemini_api_challenge/shared/widgets/loading_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatBloc _bloc = ChatBloc();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _bloc.initialize();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: Dimens.horizontalPadding,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<ChatDataState>(
                  stream: _bloc.chatStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ChatHistoryWidget(
                        chats: snapshot.data!.history.reversed.toList(),
                      );
                    }
                    return const LoadingWidget();
                  }),
            ),
            SafeArea(
              top: false,
              child: ChatTextInputWidget(
                callback: _bloc.addEvent,
              ),
            ),
            const GapBox(gap: Gap.xxs),
          ],
        ),
      ),
    );
  }
}

class ChatTextInputWidget extends StatefulWidget {
  const ChatTextInputWidget({
    super.key,
    required this.callback,
  });

  final Function(String data) callback;

  @override
  State<ChatTextInputWidget> createState() => _ChatTextInputWidgetState();
}

class _ChatTextInputWidgetState extends State<ChatTextInputWidget> {
  final TextEditingController _controller = TextEditingController();

  bool sendActive = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void onSend() {
    if (_controller.text.trim().isNotEmpty) {
      widget.callback(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 1,
      minLines: 1,
      controller: _controller,
      textInputAction: TextInputAction.send,
      onChanged: (value) {
        setState(() => sendActive = value.trim().isNotEmpty);
      },
      onSubmitted: (value) => onSend(),
      decoration: InputDecoration(
        hintText: 'Start Typing...',
        prefixIcon: IconButton(
          onPressed: () {},
          iconSize: 24,
          icon: ImageIcon(
            const AssetImage('assets/images/ic_camera.png'),
            color: context.colorScheme.primary,
          ),
        ),
        suffixIcon: IconButton(
          iconSize: 24,
          onPressed: onSend,
          icon: Opacity(
            opacity: sendActive ? 1 : 0.3,
            child: ImageIcon(
              const AssetImage('assets/images/ic_send.png'),
              size: 24,
              color: context.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class ChatHistoryWidget extends StatefulWidget {
  const ChatHistoryWidget({super.key, required this.chats});

  final List<ChatModel> chats;

  @override
  State<ChatHistoryWidget> createState() => _ChatHistoryWidgetState();
}

class _ChatHistoryWidgetState extends State<ChatHistoryWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.chats.length,
      reverse: true,
      itemBuilder: (context, index) {
        final chat = widget.chats[index];
        return IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Visibility(
                  visible: chat.chatFrom == ChatFrom.bot,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: ChatUserIconWidget(
                      iconAsset: 'ic_chat_bot.png',
                      isPrimaryColor: true,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      chat.content,
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
                ),
                Visibility(
                  visible: chat.chatFrom == ChatFrom.user,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: ChatUserIconWidget(
                      iconAsset: 'ic_chat_user.png',
                      isPrimaryColor: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ChatUserIconWidget extends StatelessWidget {
  const ChatUserIconWidget({
    super.key,
    required this.iconAsset,
    required this.isPrimaryColor,
  });

  final String iconAsset;
  final bool isPrimaryColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isPrimaryColor
                ? context.colorScheme.primaryContainer
                : context.colorScheme.secondaryContainer,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              'assets/images/$iconAsset',
              width: 24,
              height: 24,
              color: isPrimaryColor
                  ? context.colorScheme.primary
                  : context.colorScheme.secondary,
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Container(
                color: isPrimaryColor
                    ? context.colorScheme.onPrimaryContainer
                    : context.colorScheme.onSecondaryContainer,
                constraints: const BoxConstraints(minHeight: 20),
                width: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
