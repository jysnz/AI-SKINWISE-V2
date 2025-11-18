import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// --- GLOBAL CONSTANTS ---
const Color _kPrimaryBlue = Color(0xFF1877F2);
const Color _kDeletedRed = Color(0xFFDC3545);
const Color _kUnselectedTabColor = Colors.black87;
const Color _kHistoryDateColor = Color(0xFF555555);

// --- 1. DATA MODELS AND ENUMS ---
class ArchiveItemData {
  final String title;
  final String subtitle;
  final String deletedDate;

  const ArchiveItemData({
    required this.title,
    required this.subtitle,
    required this.deletedDate,
  });
}

enum SortOption { date, name }

// -----------------------------------------------------------------
// --- SORTING MIXIN (Reusable Logic) ---
// -----------------------------------------------------------------
mixin SortableContent<T extends StatefulWidget> on State<T> {
  SortOption _currentSort = SortOption.date;
  bool _isSortMenuOpen = false;

  void sortItems(
    SortOption option,
    List<ArchiveItemData> itemsToSort,
    Function(void Function()) setter,
  ) {
    setter(() {
      _currentSort = option;
      itemsToSort.sort((a, b) {
        if (option == SortOption.name) {
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        } else if (option == SortOption.date) {
          // Remove "Deleted: " prefix if present
          final dateAString = a.deletedDate.replaceFirst('Deleted: ', '');
          final dateBString = b.deletedDate.replaceFirst('Deleted: ', '');

          try {
            // Parse dates using US locale for English month names
            final DateFormat formatter = DateFormat('MMMM d, yyyy', 'en_US');
            final dateA = formatter.parse(dateAString);
            final dateB = formatter.parse(dateBString);

            // Sort by date descending (newest first)
            return dateB.compareTo(dateA);
          } catch (e) {
            // Fallback: If parsing fails, maintain current order
            return 0;
          }
        }
        return 0;
      });
      _isSortMenuOpen = false;
    });
  }

  void toggleSortMenu(Function(void Function()) setter) {
    setter(() {
      _isSortMenuOpen = !_isSortMenuOpen;
    });
  }

  Widget buildDropdownOption(
    SortOption option,
    String label,
    Function(SortOption) onSelect,
  ) {
    final bool isSelected = _currentSort == option;
    return GestureDetector(
      onTap: () => onSelect(option),
      child: Container(
        color: isSelected ? _kPrimaryBlue : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// --- 2. Archive Item Tile Widget ---
// -----------------------------------------------------------------
class ArchiveItemTile extends StatelessWidget {
  final ArchiveItemData item;

  const ArchiveItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    bool isArchived = item.deletedDate.startsWith('Deleted:');

    String dateDisplay =
        isArchived
            ? item.deletedDate.replaceFirst('Deleted: ', '')
            : item.deletedDate;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),

            // Blue square icon
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _kPrimaryBlue,
                borderRadius: BorderRadius.circular(6),
              ),
            ),

            // Title, subtitle, and date
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _kPrimaryBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  isArchived ? 'Deleted: $dateDisplay' : dateDisplay,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: isArchived ? _kDeletedRed : _kHistoryDateColor,
                  ),
                ),
              ],
            ),

            // Action buttons for archived items
            trailing:
                isArchived
                    ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.refresh,
                            size: 24,
                            color: _kPrimaryBlue,
                          ),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 24,
                            color: _kDeletedRed,
                          ),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    )
                    : null,
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------
// --- 3. History Content (FIXED) ---
// -----------------------------------------------------------------
class HistoryContent extends StatefulWidget {
  const HistoryContent({super.key});

  @override
  State<HistoryContent> createState() => _HistoryContentState();
}

class _HistoryContentState extends State<HistoryContent> with SortableContent {
  List<ArchiveItemData> _historyItems = [];

  @override
  void initState() {
    super.initState();
    _historyItems = [
      ArchiveItemData(
        title: 'Acne',
        subtitle: 'Common',
        deletedDate: 'January 5, 2025',
      ),
      ArchiveItemData(
        title: 'Eczema',
        subtitle: 'Rare',
        deletedDate: 'February 9, 2025',
      ),
      ArchiveItemData(
        title: 'Psoriasis',
        subtitle: 'Severe',
        deletedDate: 'May 16, 2025',
      ),
      ArchiveItemData(
        title: 'Acne',
        subtitle: 'Common',
        deletedDate: 'November 24, 2025',
      ),
    ];
    sortItems(SortOption.name, _historyItems, setState); // Default sort by name
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          // Main Content Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "Saved" label and Sort button
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 12.0,
                  bottom: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Saved',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),

                    // Sort button with dropdown arrow
                    GestureDetector(
                      onTap: () => toggleSortMenu(setState),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Sort',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange.shade400,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.orange.shade400,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // History List (FIXED: Wrapped ListView.builder in Expanded)
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _historyItems.length,
                  itemBuilder: (context, index) {
                    return ArchiveItemTile(item: _historyItems[index]);
                  },
                ),
              ),
            ],
          ),

          // Floating Sort Dropdown Menu
          if (_isSortMenuOpen)
            Positioned(
              top: 40,
              right: 16,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildDropdownOption(
                        SortOption.name,
                        'Name (A-Z)',
                        (option) => sortItems(option, _historyItems, setState),
                      ),
                      const Divider(height: 1, thickness: 1),
                      buildDropdownOption(
                        SortOption.date,
                        'Date',
                        (option) => sortItems(option, _historyItems, setState),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------
// --- 4. Archive Content (FIXED) ---
// -----------------------------------------------------------------
class Archive extends StatefulWidget {
  const Archive({super.key});

  @override
  State<Archive> createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> with SortableContent {
  List<ArchiveItemData> _archivedItems = [];

  @override
  void initState() {
    super.initState();
    _archivedItems = [
      ArchiveItemData(
        title: 'Acne',
        subtitle: 'Common',
        deletedDate: 'Deleted: January 5, 2025',
      ),
      ArchiveItemData(
        title: 'Eczema',
        subtitle: 'Rare',
        deletedDate: 'Deleted: February 9, 2025',
      ),
      ArchiveItemData(
        title: 'Psoriasis',
        subtitle: 'Severe',
        deletedDate: 'Deleted: May 16, 2025',
      ),
      ArchiveItemData(
        title: 'Acne',
        subtitle: 'Common',
        deletedDate: 'Deleted: November 24, 2025',
      ),
      ArchiveItemData(
        title: 'Acne',
        subtitle: 'Common',
        deletedDate: 'Deleted: December 25, 2025',
      ),
    ];
    sortItems(SortOption.date, _archivedItems, setState); // Default sort: Date
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Note text and Date button
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 12.0,
                  bottom: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'note: it will be automatically permanently removed after 30 days',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Sort button with dropdown arrow
                    GestureDetector(
                      onTap: () => toggleSortMenu(setState),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Sort',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange.shade400,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.orange.shade400,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Archive List (FIXED: Wrapped ListView.builder in Expanded)
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _archivedItems.length,
                  itemBuilder: (context, index) {
                    return ArchiveItemTile(item: _archivedItems[index]);
                  },
                ),
              ),
            ],
          ),

          // Floating Sort Dropdown Menu
          if (_isSortMenuOpen)
            Positioned(
              top: 40,
              right: 16,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildDropdownOption(
                        SortOption.name,
                        'Name (A-Z)',
                        (option) => sortItems(option, _archivedItems, setState),
                      ),
                      const Divider(height: 1, thickness: 1),
                      buildDropdownOption(
                        SortOption.date,
                        'Date',
                        (option) => sortItems(option, _archivedItems, setState),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------
// --- 5. Main Screen Container ---
// -----------------------------------------------------------------
class ArchiveScreenContainer extends StatelessWidget {
  const ArchiveScreenContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {},
          ),

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Column(
              children: [
                TabBar(
                  isScrollable: false,
                  tabs: const [Tab(text: 'History'), Tab(text: 'Archived')],
                  indicatorPadding: EdgeInsets.zero,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: const BoxDecoration(color: _kPrimaryBlue),
                  labelColor: Colors.white,
                  unselectedLabelColor: _kUnselectedTabColor,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: Colors.grey),
              ],
            ),
          ),
        ),

        body: TabBarView(children: [HistoryContent(), Archive()]),
      ),
    );
  }
}
