#!/usr/bin/env python
"""
Script to populate services with the client's requested services
Run this with: python populate_services.py
"""
import os
import django

# Setup Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')
django.setup()

from services.models import Service, MembershipPlan

def populate_services():
    """Populate services with client's requested services"""
    
    services_data = [
        {
            'name': 'Private Lessons',
            'category': 'lessons',
            'description': 'We offer personalized chess coaching at home, ensuring those with a keen interest to learn chess receive dedicated attention and tailored instruction.',
            'features': [
                'One-on-one personalized coaching',
                'Flexible scheduling',
                'Customized learning pace',
                'Home-based instruction',
                'Expert trainers'
            ],
            'price': 2500.00,
            'duration': 'Per Session (1 hour)',
            'is_active': True,
            'is_featured': True,
            'display_order': 1
        },
        {
            'name': 'Chess in Schools',
            'category': 'training',
            'description': 'Offering unique combinations such as chess and mathematics, chess and reading, and insightful educational integration programs.',
            'features': [
                'Chess and Mathematics integration',
                'Chess and Reading programs',
                'School curriculum alignment',
                'Group instruction',
                'Educational benefits'
            ],
            'price': 15000.00,
            'duration': 'Per Month (School Program)',
            'is_active': True,
            'is_featured': True,
            'display_order': 2
        },
        {
            'name': 'Group Sessions',
            'category': 'training',
            'description': 'We conduct group training sessions during weekends and school holidays, perfect for collaborative learning.',
            'features': [
                'Weekend sessions',
                'Holiday programs',
                'Peer learning environment',
                'Competitive practice',
                'Social interaction'
            ],
            'price': 1500.00,
            'duration': 'Per Session (2 hours)',
            'is_active': True,
            'is_featured': True,
            'display_order': 3
        },
        {
            'name': 'Online Resources & Classes',
            'category': 'lessons',
            'description': 'Offers an unrivaled online classroom experience with access to digital resources, live classes, and recorded sessions.',
            'features': [
                'Live online classes',
                'Recorded sessions',
                'Digital learning materials',
                'Interactive platform',
                'Learn from anywhere'
            ],
            'price': 2000.00,
            'duration': 'Per Month',
            'is_active': True,
            'is_featured': True,
            'display_order': 4
        },
        {
            'name': 'Tournaments and Competitions',
            'category': 'tournaments',
            'description': 'From rapid chess to classical tournaments, participate in various competitive events to test and improve your skills.',
            'features': [
                'Rapid chess tournaments',
                'Classical tournaments',
                'Blitz competitions',
                'Rating opportunities',
                'Prizes and recognition'
            ],
            'price': 500.00,
            'duration': 'Per Tournament Entry',
            'is_active': True,
            'is_featured': True,
            'display_order': 5
        },
        {
            'name': 'Mentorship Programs',
            'category': 'training',
            'description': 'We are Building Strategic Thinkers, Empowering Youth Through Chess, Developing Lifelong Skills through dedicated mentorship.',
            'features': [
                'Personal mentor assignment',
                'Strategic thinking development',
                'Youth empowerment focus',
                'Lifelong skills building',
                'Career guidance in chess'
            ],
            'price': 5000.00,
            'duration': 'Per Month (3 sessions)',
            'is_active': True,
            'is_featured': False,
            'display_order': 6
        },
        {
            'name': 'Chess Library',
            'category': 'workshops',
            'description': 'Explore our extensive collection of chess books, magazines, and resources in our club library.',
            'features': [
                'Extensive book collection',
                'Chess magazines',
                'Digital resources',
                'Study materials',
                'Member access included'
            ],
            'price': 0.00,
            'duration': 'Free for Members',
            'is_active': True,
            'is_featured': False,
            'display_order': 7
        },
        {
            'name': 'Chess Equipment',
            'category': 'workshops',
            'description': "High-quality chess equipment available for purchase or rental. We've got all you need - boards, pieces, clocks, and more.",
            'features': [
                'Professional chess sets',
                'Digital chess clocks',
                'Tournament boards',
                'Purchase or rental options',
                'Quality guaranteed'
            ],
            'price': 1000.00,
            'duration': 'Varies by item',
            'is_active': True,
            'is_featured': False,
            'display_order': 8
        },
        {
            'name': 'Chess Workshops and Seminars',
            'category': 'workshops',
            'description': 'Broaden your understanding of the game through specialized workshops covering openings, endgames, tactics, and strategy.',
            'features': [
                'Opening theory workshops',
                'Endgame mastery sessions',
                'Tactical training',
                'Strategic concepts',
                'Guest master classes'
            ],
            'price': 3000.00,
            'duration': 'Per Workshop (Full Day)',
            'is_active': True,
            'is_featured': False,
            'display_order': 9
        },
        {
            'name': 'Chess Community and Networking',
            'category': 'workshops',
            'description': 'Connect with fellow chess enthusiasts, share experiences, and build lasting relationships in our vibrant chess community.',
            'features': [
                'Community events',
                'Networking opportunities',
                'Social chess games',
                'Club championships',
                'Member activities'
            ],
            'price': 0.00,
            'duration': 'Free for Members',
            'is_active': True,
            'is_featured': False,
            'display_order': 10
        },
    ]
    
    created_count = 0
    updated_count = 0
    
    for service_data in services_data:
        service, created = Service.objects.update_or_create(
            name=service_data['name'],
            defaults=service_data
        )
        if created:
            created_count += 1
            print(f"✓ Created: {service.name}")
        else:
            updated_count += 1
            print(f"↻ Updated: {service.name}")
    
    print(f"\n✅ Services populated successfully!")
    print(f"   Created: {created_count}")
    print(f"   Updated: {updated_count}")
    print(f"   Total: {Service.objects.count()}")


def populate_membership_plans():
    """Create default membership plans"""
    
    plans_data = [
        {
            'name': 'Monthly Membership',
            'plan_type': 'monthly',
            'price': 3000.00,
            'description': 'Standard monthly membership with full access to club facilities and resources.',
            'features': [
                'Access to all group sessions',
                'Library access',
                'Tournament participation',
                'Community events',
                'Monthly newsletter'
            ],
            'is_active': True,
            'is_default': True,
            'display_order': 1
        },
        {
            'name': 'Quarterly Membership',
            'plan_type': 'quarterly',
            'price': 8000.00,
            'description': 'Three-month membership with discounted rate and additional benefits.',
            'features': [
                'All monthly benefits',
                'Save KES 1,000',
                'Priority tournament registration',
                'Free equipment rental',
                '1 free workshop'
            ],
            'is_active': True,
            'is_default': False,
            'display_order': 2
        },
        {
            'name': 'Semi-Annual Membership',
            'plan_type': 'semi_annual',
            'price': 15000.00,
            'description': 'Six-month membership with significant savings and premium benefits.',
            'features': [
                'All quarterly benefits',
                'Save KES 3,000',
                '2 free workshops',
                'Personalized coaching session',
                'Exclusive member events'
            ],
            'is_active': True,
            'is_default': False,
            'display_order': 3
        },
        {
            'name': 'Annual Membership',
            'plan_type': 'annual',
            'price': 28000.00,
            'description': 'Full-year membership with maximum value and VIP benefits.',
            'features': [
                'All semi-annual benefits',
                'Save KES 8,000',
                'Unlimited workshops',
                '3 private coaching sessions',
                'VIP tournament access',
                'Member gift package'
            ],
            'is_active': True,
            'is_default': False,
            'display_order': 4
        },
    ]
    
    created_count = 0
    updated_count = 0
    
    for plan_data in plans_data:
        plan, created = MembershipPlan.objects.update_or_create(
            name=plan_data['name'],
            defaults=plan_data
        )
        if created:
            created_count += 1
            print(f"✓ Created: {plan.name}")
        else:
            updated_count += 1
            print(f"↻ Updated: {plan.name}")
    
    print(f"\n✅ Membership plans populated successfully!")
    print(f"   Created: {created_count}")
    print(f"   Updated: {updated_count}")
    print(f"   Total: {MembershipPlan.objects.count()}")


if __name__ == '__main__':
    print("=" * 60)
    print("POPULATING SERVICES AND MEMBERSHIP PLANS")
    print("=" * 60)
    print()
    
    populate_services()
    print()
    populate_membership_plans()
    
    print()
    print("=" * 60)
    print("COMPLETED!")
    print("=" * 60)
