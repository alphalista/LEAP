import { Home } from "lucide-react"
import Image from 'next/image';
import {
    Sidebar,
    SidebarContent,
    SidebarFooter,
    SidebarGroup,
    SidebarGroupLabel,
    SidebarHeader,
    SidebarMenu,
    SidebarMenuButton,
    SidebarMenuItem,
  } from "@/components/ui/sidebar"
  import leap_icon from '../../public/leap_black.svg'


  // Menu items
  const items = [
    {
        title: "Home", 
        url: "", 
        icon: Home, 
    }
  ]
   
  export function AppSidebar() {
    return (
      <Sidebar>
        <SidebarHeader />
        <SidebarMenu>
            <SidebarMenuItem className="data-[state=open]:bg-sidebar-accent data-[state=open]:text-sidebar-accent-foreground h-2">
                <div className="data-[state=open]:bg-sidebar-accent data-[state=open]:text-sidebar-accent-foreground">
                    <div className="flex aspect-square size-24 items-start justify-center rounded-lg bg-sidebar-secondary text-sidebar-primary-foreground mt-5 ml-6">
                        <Image
                            src={leap_icon}
                            alt="v13 image"
                            width={500}
                            height={100}
                        />
                    </div>
                </div>
            </SidebarMenuItem>
        </SidebarMenu>
        <SidebarContent>
          <SidebarGroup />
            <SidebarGroupLabel></SidebarGroupLabel>
            <SidebarMenu>
                {items.map((item) => (
                    <SidebarMenuItem key={item.title}>
                        <SidebarMenuButton asChild>
                            <a href={item.url}>
                                <item.icon />
                                <span>{item.title}</span>
                            </a>
                        </SidebarMenuButton>
                    </SidebarMenuItem>
                ))}
            </SidebarMenu>
          <SidebarGroup />
        </SidebarContent>
        <SidebarFooter />
      </Sidebar>
    )
  }