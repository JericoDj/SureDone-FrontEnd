import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/fitness/domain/fitness_models.dart';
import 'package:suredone/features/tutor/domain/tutor_models.dart';

class FitnessScreen extends StatefulWidget {
  const FitnessScreen({super.key});

  @override
  State<FitnessScreen> createState() => _FitnessScreenState();
}

enum SortOption { lowToHigh, highToLow, none }

class _FitnessScreenState extends State<FitnessScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Filter State
  String _searchQuery = '';
  SortOption _sortOption = SortOption.none;
  RangeValues _currentPriceRange = const RangeValues(0, 3000);
  String? _selectedService;

  final List<FitnessCoach> _coaches = [
    // Personal Training
    const FitnessCoach(
      id: 'pt1', name: 'Alex Johnson', avatarUrl: 'https://i.pravatar.cc/150?u=Alex', rating: 4.8, pricePerHour: 800,
      bio: 'Certified PT specializing in weight loss and muscle gain.',
      services: ['1-on-1 Training', 'Nutrition Plan'], focusAreas: ['Weight Loss', 'Strength'],
      category: FitnessCategory.personalTraining,
      reviews: [
        Review(userName: "John D.", comment: "Great results in 3 months!", rating: 5.0, date: "Oct 10, 2023"),
        Review(userName: "Mike L.", comment: "Very knowledgeable and motivating.", rating: 4.5, date: "Sep 22, 2023"),
      ],
    ),
    const FitnessCoach(
      id: 'pt2', name: 'Sarah Connor', avatarUrl: 'https://i.pravatar.cc/150?u=SarahC', rating: 4.9, pricePerHour: 950,
      bio: 'Elite strength coach for athletes.',
      services: ['Strength Coaching', 'Performance Analysis'], focusAreas: ['Athletics', 'Powerlifting'],
      category: FitnessCategory.personalTraining,
      reviews: [
        Review(userName: "Terminator", comment: "Come with me if you want to lift.", rating: 5.0, date: "Aug 29, 2023"),
      ],
    ),

    // Sports Coaching
    const FitnessCoach(
      id: 'sc1', name: 'Coach Carter', avatarUrl: 'https://i.pravatar.cc/150?u=Carter', rating: 5.0, pricePerHour: 1200,
      bio: 'Basketball skills trainer with 10 years experience.',
      services: ['Dribbling Drills', 'Shooting Mechanics'], focusAreas: ['Basketball', 'Agility'],
      category: FitnessCategory.sportsCoaching,
      reviews: [
        Review(userName: "LeBron", comment: "Helped fixing my jumpshot.", rating: 5.0, date: "Nov 5, 2023"),
      ],
    ),
    const FitnessCoach(
      id: 'sc2', name: 'Maria Sharapova', avatarUrl: 'https://i.pravatar.cc/150?u=Maria', rating: 4.7, pricePerHour: 1500,
      bio: 'Tennis pro offering advanced techniques.',
      services: ['Serve Clinic', 'Match Strategy'], focusAreas: ['Tennis', 'Mental Game'],
      category: FitnessCategory.sportsCoaching,
    ),

    // Classes & Group Fitness
    const FitnessCoach(
      id: 'gf1', name: 'Zumba with Jessica', avatarUrl: 'https://i.pravatar.cc/150?u=Jessica', rating: 4.6, pricePerHour: 300,
      bio: 'High energy Zumba classes for all levels.',
      services: ['Zumba', 'Dance Cardio'], focusAreas: ['Cardio', 'Fun'],
      category: FitnessCategory.classesGroupFitness,
      reviews: [
        Review(userName: "Linda", comment: "So much fun!", rating: 4.8, date: "Dec 1, 2023"),
      ],
    ),
    const FitnessCoach(
      id: 'gf2', name: 'Bootcamp Bob', avatarUrl: 'https://i.pravatar.cc/150?u=Bob', rating: 4.8, pricePerHour: 400,
      bio: 'Outdoor bootcamp sessions.',
      services: ['HIIT', 'Circuit Training'], focusAreas: ['Endurance', 'Full Body'],
      category: FitnessCategory.classesGroupFitness,
    ),

    // Wellness & Recovery
    const FitnessCoach(
      id: 'wr1', name: 'Yoga with Elena', avatarUrl: 'https://i.pravatar.cc/150?u=Elena', rating: 4.9, pricePerHour: 600,
      bio: 'Vinyasa flow and meditation.',
      services: ['Yoga', 'Meditation'], focusAreas: ['Flexibility', 'Mindfulness'],
      category: FitnessCategory.wellnessRecovery,
      reviews: [
        Review(userName: "Sarah", comment: "Very relaxing session.", rating: 5.0, date: "Jan 10, 2024"),
      ],
    ),
    const FitnessCoach(
      id: 'wr2', name: 'Dr. Strange', avatarUrl: 'https://i.pravatar.cc/150?u=Strange', rating: 5.0, pricePerHour: 2000,
      bio: 'Physical therapy and injury recovery.',
      services: ['Physical Therapy', 'Massage'], focusAreas: ['Rehab', 'Pain Management'],
      category: FitnessCategory.wellnessRecovery,
    ),

    // Online Coaching
    const FitnessCoach(
      id: 'oc1', name: 'Virtual Vinny', avatarUrl: 'https://i.pravatar.cc/150?u=Vinny', rating: 4.5, pricePerHour: 500,
      bio: 'Online workout plans and check-ins.',
      services: ['App-based Plans', 'Weekly Calls'], focusAreas: ['Lifestyle', 'Habits'],
      category: FitnessCategory.onlineCoaching,
    ),
     const FitnessCoach(
      id: 'oc2', name: 'Digital Dani', avatarUrl: 'https://i.pravatar.cc/150?u=Dani', rating: 4.8, pricePerHour: 550,
      bio: 'Remote nutrition and training coaching.',
      services: ['Macro Tracking', 'Video Analysis'], focusAreas: ['Nutrition', 'Form Check'],
      category: FitnessCategory.onlineCoaching,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<FitnessCoach> _getFilteredCoaches(List<FitnessCoach> source) {
    return source.where((coach) {
      // Search Query
      if (_searchQuery.isNotEmpty && !coach.name.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      // Price Range
      if (coach.pricePerHour < _currentPriceRange.start || coach.pricePerHour > _currentPriceRange.end) {
        return false;
      }
      // Service Filter
      if (_selectedService != null && !coach.services.contains(_selectedService)) {
        return false;
      }
      return true;
    }).toList()
      ..sort((a, b) {
        if (_sortOption == SortOption.lowToHigh) {
          return a.pricePerHour.compareTo(b.pricePerHour);
        } else if (_sortOption == SortOption.highToLow) {
          return b.pricePerHour.compareTo(a.pricePerHour);
        }
        return 0;
      });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final allServices = _coaches.expand((c) => c.services).toSet().toList();
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) => Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Filters", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _sortOption = SortOption.none;
                              _currentPriceRange = const RangeValues(0, 3000);
                              _selectedService = null;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text("Reset"),
                        ),
                      ],
                    ),
                    const Divider(),
                    const Text("Sort By Price", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text("Low to High"),
                          selected: _sortOption == SortOption.lowToHigh,
                          onSelected: (selected) {
                            setModalState(() => _sortOption = selected ? SortOption.lowToHigh : SortOption.none);
                          },
                        ),
                        ChoiceChip(
                          label: const Text("High to Low"),
                          selected: _sortOption == SortOption.highToLow,
                          onSelected: (selected) {
                            setModalState(() => _sortOption = selected ? SortOption.highToLow : SortOption.none);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text("Price Range (Hourly)", style: TextStyle(fontWeight: FontWeight.bold)),
                    RangeSlider(
                      values: _currentPriceRange,
                      min: 0,
                      max: 3000,
                      divisions: 30,
                      labels: RangeLabels(
                        "₱${_currentPriceRange.start.round()}",
                        "₱${_currentPriceRange.end.round()}",
                      ),
                      onChanged: (values) {
                        setModalState(() => _currentPriceRange = values);
                      },
                    ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("₱${_currentPriceRange.start.round()}"),
                        Text("₱${_currentPriceRange.end.round()}"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text("Services", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Wrap(
                          spacing: 8,
                          children: allServices.map((service) {
                            return FilterChip(
                              label: Text(service),
                              selected: _selectedService == service,
                              onSelected: (selected) {
                                setModalState(() => _selectedService = selected ? service : null);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {}); // Trigger rebuild of main screen
                          Navigator.pop(context);
                        },
                        child: const Text("Apply Filters"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fitness Professionals"),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Personal Training"),
            Tab(text: "Sports Coaching"),
            Tab(text: "Classes & Group"),
            Tab(text: "Wellness & Recovery"),
            Tab(text: "Online Coaching"),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search coach name...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: _showFilterSheet,
                  icon: const Icon(Icons.filter_list),
                  tooltip: "Filter & Sort",
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCoachGrid(_getFilteredCoaches(_coaches)), // All
                _buildCoachGrid(_getFilteredCoaches(_coaches.where((c) => c.category == FitnessCategory.personalTraining).toList())),
                _buildCoachGrid(_getFilteredCoaches(_coaches.where((c) => c.category == FitnessCategory.sportsCoaching).toList())),
                _buildCoachGrid(_getFilteredCoaches(_coaches.where((c) => c.category == FitnessCategory.classesGroupFitness).toList())),
                _buildCoachGrid(_getFilteredCoaches(_coaches.where((c) => c.category == FitnessCategory.wellnessRecovery).toList())),
                _buildCoachGrid(_getFilteredCoaches(_coaches.where((c) => c.category == FitnessCategory.onlineCoaching).toList())),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachGrid(List<FitnessCoach> coaches) {
    if (coaches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text("No coaches found matching your filters.", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7, // Adjust to fit content
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 280, // Fixed height for consistency
      ),
      itemCount: coaches.length,
      itemBuilder: (context, index) {
        final coach = coaches[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () {
                context.go('/fitness/details', extra: coach);
            },
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      image: DecorationImage(
                        image: NetworkImage(coach.avatarUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(coach.name, style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis))),
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          Text(coach.rating.toString(), style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text("₱${coach.pricePerHour.toStringAsFixed(0)}/hr", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                      const SizedBox(height: 4),
                      // Focus Areas (First 2)
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: coach.focusAreas.take(2).map((focus) => Container(
                             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(focus, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                        )).toList(),
                      ),
                      const SizedBox(height: 8),
                       SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                             context.go('/fitness/details', extra: coach);
                          }, 
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 32),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text("View Details", style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
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
