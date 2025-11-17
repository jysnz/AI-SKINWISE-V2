import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// A blue color that matches the screenshot's app bar
const Color primaryBlue = Color(0xFF007AFF);

class Messagespage extends StatefulWidget {
  const Messagespage({super.key});

  @override
  State<Messagespage> createState() => _MessagespageState();
}

class _MessagespageState extends State<Messagespage> {
  // Mock data for the contact list
  final List<MessageContact> contacts = [
    MessageContact(
      name: 'Dr. Sarah Johnson',
      message: "For now, let's start with a gentle routine first...",
      time: 'Today',
      imageUrl: 'https://placehold.co/100x100/E6A4B4/FFFFFF?text=SJ',
    ),
    MessageContact(
      name: 'Dr. Michael Lee',
      message: "I've reviewed your progress photos. The tr...",
      time: 'Yesterday',
      imageUrl: 'https://placehold.co/100x100/A4B4E6/FFFFFF?text=ML',
    ),
    MessageContact(
      name: 'Dr. Emily Chen',
      message: 'That sounds good! Let me know if you have...',
      time: 'Mon',
      imageUrl: 'https://placehold.co/100x100/B4E6A4/FFFFFF?text=EC',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // This removes the back arrow that Flutter might add automatically
        automaticallyImplyLeading: false,
        // The title is not centered in the screenshot
        centerTitle: true,
        // No shadow
        elevation: 0,
        backgroundColor: primaryBlue,
        title: const Text(
          "Messages",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Search Bar Area
          Container(
            // The blue background is removed as requested
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16), // Added top padding
            child: Container(
              decoration: BoxDecoration(
                // Changed search bar background for visibility against white
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search Messages',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
            ),
          ),

          // 2. "Contacts" Title
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 4, 16, 8), // Reduced top padding
            child: Text(
              "Contacts",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          // 3. Messages List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    // Using a network image placeholder
                    backgroundImage: NetworkImage(contact.imageUrl),
                  ),
                  title: Text(
                    contact.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    contact.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(contact.time),
                  onTap: () {
                    // Navigate to the ChatPage when a contact is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(contact: contact),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// A simple class to hold the mock data for contacts
class MessageContact {
  final String name;
  final String message;
  final String time;
  final String imageUrl;

  const MessageContact({
    required this.name,
    required this.message,
    required this.time,
    required this.imageUrl,
  });
}

// -------------------------------------------------------------------
// CHAT PAGE WIDGET
// -------------------------------------------------------------------

// A simple class to hold mock chat message data
class ChatMessage {
  final String text;
  final bool isMe;
  final String imageUrl; // For the other person's bubble

  ChatMessage({
    required this.text,
    required this.isMe,
    this.imageUrl = '',
  });
}

// The new page for an individual chat conversation
class ChatPage extends StatefulWidget {
  final MessageContact contact;

  const ChatPage({super.key, required this.contact});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Mock data for the conversation
  late final List<ChatMessage> messages;

  @override
  void initState() {
    super.initState();
    // Create mock messages, using the contact's image URL for 'their' messages
    messages = [
      ChatMessage(
        text:
        "Of course. I'd be happy to help. Can you describe what's been happening with your skin?",
        isMe: false,
        imageUrl: widget.contact.imageUrl,
      ),
      ChatMessage(
        text:
        "I've been getting small red pimples on my cheeks for about two weeks now. They're a bit itchy sometimes.",
        isMe: true,
      ),
      ChatMessage(
        text:
        "I see. Have you used any new skincare products or makeup recently?",
        isMe: false,
        imageUrl: widget.contact.imageUrl,
      ),
      ChatMessage(
        text: "Yes, I started using a new face serum last month.",
        isMe: true,
      ),
      ChatMessage(
        text:
        "That could be one possible cause. Some ingredients may irritate the skin or clog pores. \n\nHave you noticed if the breakout worsened after using it?",
        isMe: false,
        imageUrl: widget.contact.imageUrl,
      ),
      ChatMessage(
        text:
        "Yes, I think it started a few days after I began using it.",
        isMe: true,
      ),
      ChatMessage(
        text:
        "Alright. I recommend stopping that product for now. Use a mild cleanser and moisturizer suitable for sensitive skin. Avoid touching or squeezing the pimples too.",
        isMe: false,
        imageUrl: widget.contact.imageUrl,
      ),
      ChatMessage(
        text:
        "Okay, got it. Should I take any medication?",
        isMe: true,
      ),
      ChatMessage(
        text:
        "For now, let's start with a gentle routine first. If it doesn't improve in a week or two, we can prescribe a mild topical treatment. Would you like to schedule an in-person consultation so I can check your skin closely?",
        isMe: false,
        imageUrl: widget.contact.imageUrl,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Flutter automatically adds a back button
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        backgroundColor: primaryBlue, // <-- Changed from Colors.white
        titleSpacing: 0,
        // Custom title to match the screenshot
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.contact.imageUrl),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contact.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // <-- Changed from Colors.black
                  ),
                ),
                const Text(
                  'Active now',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70, // <-- Changed from Colors.green
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white), // <-- Changed from primaryBlue
            onPressed: () {
              // Navigate to the ContactProfilePage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactProfilePage(contact: widget.contact),
                ),
              );
            },
          ),
        ],
        // Set icon color for the back button
        iconTheme: const IconThemeData(color: Colors.white), // <-- Changed from primaryBlue
      ),
      body: Column(
        children: [
          // 1. Chat Messages Area
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _ChatBubble(message: messages[index]);
              },
            ),
          ),
          // 2. Message Input Bar
          _buildMessageComposer(),
        ],
      ),
    );
  }

  // Builds the message input bar at the bottom
  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(CupertinoIcons.camera, color: primaryBlue),
              onPressed: () {},
            ),
            // NEW PHOTO ICON
            IconButton(
              icon: const Icon(CupertinoIcons.photo, color: primaryBlue),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.mic, color: primaryBlue),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Message',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.smiley, color: primaryBlue),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.hand_thumbsup_fill, color: primaryBlue),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// A widget to display a single chat bubble
class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    // Align bubbles to the right if 'isMe' is true, left otherwise
    final alignment =
    message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    // Bubble color
    final color = message.isMe ? primaryBlue : Colors.grey[200];
    // Text color
    final textColor = message.isMe ? Colors.white : Colors.black87;
    // Bubble border radius
    final radius = message.isMe
        ? const BorderRadius.only(
      topLeft: Radius.circular(16),
      bottomLeft: Radius.circular(16),
      topRight: Radius.circular(16),
    )
        : const BorderRadius.only(
      topRight: Radius.circular(16),
      bottomRight: Radius.circular(16),
      topLeft: Radius.circular(16),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Use MainAxisAlignment.end for 'my' messages and .start for 'their' messages
        mainAxisAlignment:
        message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Show avatar only for 'their' messages
          if (!message.isMe)
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(message.imageUrl),
            ),
          if (!message.isMe) const SizedBox(width: 8),

          // Flexible container for the bubble
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: radius,
              ),
              child: Text(
                message.text,
                style: TextStyle(color: textColor, fontSize: 15, height: 1.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// -------------------------------------------------------------------
// NEW CONTACT PROFILE PAGE (SETTINGS)
// -------------------------------------------------------------------

class ContactProfilePage extends StatelessWidget {
  final MessageContact contact;

  const ContactProfilePage({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Standard back button
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: false,
        backgroundColor: primaryBlue,
        titleSpacing: 0,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      backgroundColor: Colors.grey[100], // Light grey background
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            // 1. Profile Info
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(contact.imageUrl),
            ),
            const SizedBox(height: 16),
            Text(
              contact.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Cosmetics Dermatology', // Placeholder specialty
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            // 2. Action Icons (Call/Video)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionIcon(CupertinoIcons.video_camera_solid, () {}),
                const SizedBox(width: 20),
                _buildActionIcon(CupertinoIcons.phone_solid, () {}),
              ],
            ),
            const SizedBox(height: 24),
            // 3. Settings Sections
            _buildSettingsSection(
              context,
              title: "Actions",
              children: [
                _buildSettingsTile(
                  icon: CupertinoIcons.share,
                  title: "Share Contact",
                  onTap: () {},
                ),
              ],
            ),
            _buildSettingsSection(
              context,
              title: "Customization",
              children: [
                _buildSettingsTile(
                  icon: CupertinoIcons.textformat_alt,
                  title: "Nicknames",
                  onTap: () {},
                ),
                _buildSettingsTile(
                  icon: CupertinoIcons.hand_thumbsup,
                  title: "Quick Reaction",
                  onTap: () {},
                  showDivider: false, // Last item
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper for the top blue action icons
  Widget _buildActionIcon(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: primaryBlue,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onPressed,
        splashRadius: 24,
      ),
    );
  }

  // Helper for creating a white container for a section
  Widget _buildSettingsSection(BuildContext context,
      {required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            // Use ClipRRect to clip the children to the rounded border
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper for the list tiles inside the sections
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: primaryBlue),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 56.0), // Align with title
            child: Divider(
              height: 1,
              color: Colors.grey[200],
            ),
          ),
      ],
    );
  }
}